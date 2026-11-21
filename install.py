import copy
import json
import os
import re
import stat
import subprocess
import sys
import uuid

sys.path.insert(0, sys.argv[2])
import questionary


def main():
    mirror = sys.argv[1]
    dry_run = "--dry-run" in sys.argv[3:]
    yes = "-y" in sys.argv[3:] or "--yes" in sys.argv[3:]

    def ask(questions):
        if not yes:
            return questionary.unsafe_prompt(questions)
        answers = {}
        for question in questions:
            if "when" in question and not question["when"](answers):
                continue
            value = question.get("default", "")
            if "validate" in question and question["validate"](value) is not True:
                sys.exit(f"-y: no usable default for \"{question['message']}\"")
            if "filter" in question:
                value = question["filter"](value)
            answers[question["name"]] = value
        return answers

    # 1. Load the install config
    with open("user_configuration.json") as f:
        config = json.load(f)
    device = config["disk_config"]["device_modifications"][0]

    # 2. Find disks
    lsblk = subprocess.run(
        ["lsblk", "-dpno", "NAME,SIZE,MODEL", "-e", "7,11"],
        capture_output=True, text=True, check=True,
    ).stdout.splitlines()
    if not lsblk:
        sys.exit("No disks found.")
    disks = [questionary.Choice(line.strip(), value=line.split()[0]) for line in lsblk]
    default_disk = device["device"]
    if default_disk not in [d.value for d in disks]:
        default_disk = disks[0].value

    # 3. Pick the disk
    disk_questions = [
        {
            "type": "select",
            "name": "disk",
            "message": "Disk to install to:",
            "choices": disks,
            "default": default_disk,
        },
        {
            "type": "press_any_key_to_continue",
            "name": "erase",
            "message": "This will ERASE the selected disk. Press any key to continue, Ctrl-C to abort.",
            "style": questionary.Style([("question", "fg:#ffffff bg:#cc0000 bold")]),
        },
    ]
    disk = ask(disk_questions)["disk"]
    if not stat.S_ISBLK(os.stat(disk).st_mode):
        sys.exit(f"{disk} is not a block device.")

    # 4. Find RAM and size swap
    with open("/proc/meminfo") as f:
        ram_bytes = int(f.readline().split()[1]) * 1024
    mib = 1024 * 1024
    swap_bytes = min(2 * ram_bytes, 8 * 1024**3) // mib * mib
    friendly_swap_bytes = f"{swap_bytes / 1024**3:.1f} GiB"

    # 5. Ask about /home
    disk_bytes = int(subprocess.run(
        ["blockdev", "--getsize64", disk], capture_output=True, text=True, check=True,
    ).stdout)
    gib = 1024**3
    root_start = device["partitions"][1]["start"]["value"]
    # Root and /home share what's left, minus 1 MiB at the end for the backup GPT.
    free_bytes = disk_bytes - root_start - swap_bytes - mib
    max_root_gib = (free_bytes - gib) // gib
    home_questions = [
        {
            "type": "confirm",
            "name": "home",
            "message": "Put /home on its own partition?",
            "default": True,
        },
        {
            "type": "text",
            "name": "root_gib",
            "message": f"Root size in GiB (max {max_root_gib} GiB):",
            "default": str(min(50, max_root_gib)),
            "when": lambda a: a["home"],
            "validate": lambda v: (
                v.isdigit() and 1 <= int(v) <= max_root_gib
            ) or f"Enter a whole number from 1 to {max_root_gib}",
        },
    ]
    home_answers = ask(home_questions)

    # 6. Size the partitions for that disk
    device["device"] = disk
    esp, root, swap = device["partitions"]
    if home_answers["home"]:
        root["size"]["value"] = int(home_answers["root_gib"]) * gib
        home = copy.deepcopy(root)
        home["mountpoint"] = "/home"
        home["obj_id"] = str(uuid.uuid4())
        home["start"]["value"] = root["start"]["value"] + root["size"]["value"]
        home["size"]["value"] = free_bytes - root["size"]["value"]
        device["partitions"] = [esp, root, home, swap]
        before_swap = home
    else:
        root["size"]["value"] = free_bytes
        before_swap = root
    swap["start"]["value"] = before_swap["start"]["value"] + before_swap["size"]["value"]
    swap["size"]["value"] = swap_bytes

    # 7. Confirm the partition layout
    layout = [("/boot", "fat32", "1 GiB", "EFI")]
    if home_answers["home"]:
        layout.append(("/", "ext4", f"{root['size']['value'] / gib:.1f} GiB", "root"))
        layout.append(("/home", "ext4", f"{home['size']['value'] / gib:.1f} GiB", "home, rest of the disk"))
    else:
        layout.append(("/", "ext4", f"{root['size']['value'] / gib:.1f} GiB", "root, rest of the disk"))
    layout.append(("[SWAP]", "linux-swap", friendly_swap_bytes, "swap, 2x RAM, max 8 GiB"))
    layout_lines = "".join(
        f"  - {path:<6} {fs:<11} {size:<18} ({description})\n"
        for path, fs, size, description in layout
    )
    layout_questions = [
        {
            "type": "press_any_key_to_continue",
            "name": "layout",
            "message": (
                f"RAM: {ram_bytes / gib:.1f} GiB\n"
                "Layout:\n"
                f"{layout_lines}"
                "Press any key to continue, Ctrl-C to abort."
            ),
        },
    ]
    ask(layout_questions)

    # 8. Set the root password
    default_root_password = os.environ.get("DEFAULT_ROOT_PASSWORD", "")
    root_hint = f" (default={default_root_password})" if default_root_password else ""
    root_questions = [
        {
            "type": "password",
            "name": "root_password",
            "message": f"Root password{root_hint}:",
            "validate": lambda p: bool(p or default_root_password) or "Password can't be empty",
            "filter": lambda p: p or default_root_password,
        },
        {
            "type": "password",
            "name": "root_confirm",
            "message": "Confirm root password:",
            "filter": lambda p: p or default_root_password,
        },
    ]
    while True:
        answers = ask(root_questions)
        if answers["root_password"] == answers["root_confirm"]:
            break
        questionary.print("Root passwords don't match, try again.", style="fg:red")
    root_hash = subprocess.run(
        ["openssl", "passwd", "-6", "-stdin"],
        input=answers["root_password"], capture_output=True, text=True, check=True,
    ).stdout.strip()

    # 9. Create users
    default_user_password = os.environ.get("DEFAULT_USER_PASSWORD", "")
    user_hint = f" (default={default_user_password})" if default_user_password else ""
    users = []
    user_questions = [
        {
            "type": "confirm",
            "name": "create",
            "message": "Create a new user?",
            "default": False,
        },
        {
            "type": "text",
            "name": "username",
            "message": "Username:",
            "when": lambda a: a["create"],
            "validate": lambda name: (
                "Lowercase letters, digits, _ and -, starting with a letter or _"
                if not re.fullmatch(r"[a-z_][a-z0-9_-]{0,31}", name)
                else f"User {name} already exists"
                if name in ["root"] + [u["username"] for u in users]
                else True
            ),
        },
        {
            "type": "password",
            "name": "password",
            "message": f"Password{user_hint}:",
            "when": lambda a: a["create"],
            "validate": lambda p: bool(p or default_user_password) or "Password can't be empty",
            "filter": lambda p: p or default_user_password,
        },
        {
            "type": "password",
            "name": "confirm",
            "message": "Confirm password:",
            "when": lambda a: a["create"],
            "filter": lambda p: p or default_user_password,
        },
        {
            "type": "confirm",
            "name": "sudo",
            "message": "Give this user sudo?",
            "default": True,
            "when": lambda a: a["create"],
        },
    ]
    while True:
        answers = ask(user_questions)
        if not answers["create"]:
            break
        if answers["password"] != answers["confirm"]:
            questionary.print("Passwords don't match, this user wasn't added.", style="fg:red")
            continue
        user_hash = subprocess.run(
            ["openssl", "passwd", "-6", "-stdin"],
            input=answers["password"], capture_output=True, text=True, check=True,
        ).stdout.strip()
        users.append({
            "username": answers["username"],
            "enc_password": user_hash,
            "sudo": answers["sudo"],
            "groups": [],
        })

    # 10. Save the configuration
    config["mirror_config"]["custom_servers"] = [{"url": mirror}] if mirror else []
    # Files copied into the new system before post-install.sh runs there.
    files = {
        "/etc/arch-bootstrap/nix/flake.nix": "flake.nix",
        "/etc/arch-bootstrap/nix/flake.lock": "flake.lock",
        "/etc/systemd/system/ufw-allow-ssh.service": "ufw-allow-ssh.service",
        "/etc/systemd/system/nix-setup.service": "nix-setup.service",
        "/etc/skel/.zshrc": "zshrc",
        "/etc/xdg/hypr/hyprland.lua": "hyprland.lua",
        "/etc/gitconfig": "gitconfig",
        "/etc/tmux.conf": "tmux.conf",
        "/etc/skel/.config/ghostty/config": "ghostty.config",
    }
    config["custom_commands"] = []
    for target, source in files.items():
        with open(source) as f:
            content = f.read()
        config["custom_commands"].append(
            f"mkdir -p {os.path.dirname(target)}\ncat >{target} <<'FILE_EOF'\n{content}FILE_EOF\n"
        )
    with open("post-install.sh") as f:
        config["custom_commands"].append(f.read())
    if os.environ.get("ALLOW_ROOT_SSH") == "1":
        config["custom_commands"].append(
            "mkdir -p /etc/ssh/sshd_config.d\n"
            "echo 'PermitRootLogin yes' >/etc/ssh/sshd_config.d/10-root-login.conf\n"
        )
    with open("user_configuration.json", "w") as f:
        json.dump(config, f, indent=4)

    # 11. Save the credentials
    fd = os.open("user_credentials.json", os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "w") as f:
        json.dump({"root_enc_password": root_hash, "users": users}, f)

    # 12. Install
    if dry_run:
        return
    archinstall_args = [
        "--config", "user_configuration.json",
        "--creds", "user_credentials.json",
        "--silent",
        *os.environ.get("ARCHINSTALL_FLAGS", "").split(),
    ]
    command = ["archinstall", *archinstall_args]
    if os.environ.get("SKIP_COUNTDOWN") == "1":
        # archinstall has no flag to skip its last-chance countdown before wiping the disk.
        command = ["python", "-c", (
            "import sys\n"
            "import archinstall.lib.menu.util as util\n"
            "util.delayed_warning = lambda message: True\n"
            "from archinstall.main import main\n"
            "sys.argv[0] = 'archinstall'\n"
            "sys.exit(main())\n"
        ), *archinstall_args]
    if subprocess.run(command).returncode != 0:
        sys.exit("Install failed, not rebooting.")

    # 13. Reboot
    subprocess.run(["umount", "-R", "/mnt"])
    os.execvp("reboot", ["reboot"])


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit("Aborted.")
