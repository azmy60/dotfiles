# dotfiles

## Full installation

To automate the process of setting up a new machine:

1. Boot [archlinux](https://archlinux.org/download/) live ISO
2. Run this

```bash
curl -fsSL https://azmy60.github.io/dotfiles/install.sh | bash
```
## Manual installation

On an existing machine, just inspect the config files manually.

## Development

1. Make sure you have [quickemu](https://github.com/quickemu-project/quickemu), `docker`, and `python3` installed.

2. Run `./dev.sh` to download the Arch ISO (first run only), start the package cache and serve this folder.

3. Boot a VM using `quickemu`:

   ```bash
   quickemu --vm quickemu.conf --delete-disk
   quickemu --vm quickemu.conf
   ```

4. In the live ISO, run:

   ```bash
   curl -fsSL http://10.0.2.2:8000/install.dev.sh | bash
   ```

   To go through the prompts without running archinstall, run:

   ```bash
   curl -fsSL http://10.0.2.2:8000/install.dev.sh | bash -s -- --dry-run
   ```

   Add `-y` to accept every default without prompting.
