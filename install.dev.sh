#!/usr/bin/env bash
set -euo pipefail

dir=$(dirname "$(realpath "$0")")
export REPO=file://$dir
export MIRROR='http://10.0.2.2:9129/repo/archlinux/$repo/os/$arch'
export SKIP_COUNTDOWN=1
export ARCHINSTALL_FLAGS='--skip-wkd --skip-ntp --skip-version-check --no-pkg-lookups'
export DEFAULT_ROOT_PASSWORD=root
export DEFAULT_USER_PASSWORD=123
export ALLOW_ROOT_SSH=1

# Clean up after a previous failed run so the installer can start over.
swapoff -a
if mountpoint -q /mnt; then
  umount -R /mnt
fi

bash "$dir/install.sh" "$@"
