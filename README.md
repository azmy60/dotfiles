# dotfiles

## Spec

For light programming (nvim) and browsing (firefox), you just need 4GB RAM + 32GB disk minimum.

For heavy gaming & heavy programming, I can personally sit comfortably with 16GB RAM + 512GB disk.

## Full installation

To automate the process of setting up a new machine:

1. Boot [archlinux](https://archlinux.org/download/) live ISO (v2026.11.01)
2. Run this

```bash
curl -fsSL azmy60.github.io/dotfiles/install.sh | bash
```

## Manual installation

On an existing machine, just inspect the config files manually.

## Development

You can develop and test this in any environment. You don't need arch.

Just make sure you have [quickemu](https://github.com/quickemu-project/quickemu),
`docker` and `genisoimage` installed.

After that, run `./dev.sh`.

In the live ISO, run `./install.dev.sh`.

To go through the prompts without running archinstall, add `--dry-run` to the end.

Add `-y` to accept every default without prompting.
