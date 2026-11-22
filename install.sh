#!/usr/bin/env bash
set -euo pipefail

REPO=${REPO:-https://azmy60.github.io/dotfiles}
MIRROR=${MIRROR-}
QUESTIONARY_WHEEL=questionary-2.1.1-py3-none-any.whl
QUESTIONARY_URL=https://files.pythonhosted.org/packages/3c/26/1062c7ec1b053db9e499b4d2d5bc231743201b74051c973dadeac80a8f43/$QUESTIONARY_WHEEL
QUESTIONARY_SHA256=a51af13f345f1cdea62347589fbb6df3b290306ab8930713bfae4d475a7d4a59

pacman -Sy --needed --noconfirm python-prompt_toolkit
curl -fsSLO "$QUESTIONARY_URL"
sha256sum -c <<<"$QUESTIONARY_SHA256  $QUESTIONARY_WHEEL"

curl -fsSLO "$REPO/user_configuration.json"
curl -fsSLO "$REPO/install.py"
curl -fsSLO "$REPO/flake.nix"
curl -fsSLO "$REPO/flake.lock"
curl -fsSLO "$REPO/ufw-allow-ssh.service"
curl -fsSLO "$REPO/nix-setup.service"
curl -fsSLO "$REPO/llama-setup.service"
curl -fsSL "$REPO/.zshrc" -o zshrc
curl -fsSLO "$REPO/hyprland.lua"
curl -fsSLO "$REPO/gitconfig"
curl -fsSL "$REPO/.tmux.conf" -o tmux.conf
curl -fsSLO "$REPO/ghostty.config"

# Runs inside the new system at the end of archinstall.
cat >post-install.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# The docker group only exists once docker is installed
for user in $(getent group wheel | cut -d: -f4 | tr , ' '); do
  usermod -aG docker "$user"
done

# zsh isn't installed yet when archinstall creates the users, so they start on bash.
for user in $(getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 {print $1}'); do
  usermod -s /usr/bin/zsh "$user"
  # /etc/skel was copied when the user was created, before these files existed.
  home=$(getent passwd "$user" | cut -d: -f6)
  cp -rn /etc/skel/. "$home/"
  chown -R "$user:$(id -gn "$user")" "$home"
done
useradd -D -s /usr/bin/zsh

# nvim comes from nix, so use its full path for tools like sudo that don't load nix's PATH.
cat >>/etc/environment <<'ENV'
EDITOR=/nix/var/nix/profiles/default/bin/nvim
VISUAL=/nix/var/nix/profiles/default/bin/nvim
ENV

# TPM isn't in the official repos.
git clone --depth 1 --branch v3.1.0 https://github.com/tmux-plugins/tpm /usr/share/tmux-plugin-manager

# Firewall: ufw can't change rules until it's running, so allow SSH on first boot.
systemctl enable ufw-allow-ssh.service

systemctl enable nix-setup.service
systemctl enable llama-setup.service
EOF

# stdin is the piped script, so prompts must read from the terminal.
exec python -I install.py "$MIRROR" "$PWD/$QUESTIONARY_WHEEL" "$@" </dev/tty
