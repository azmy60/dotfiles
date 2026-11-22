#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p data
if [[ ! -e data/archlinux.iso ]]; then
  (cd data && quickget archlinux latest)
  rm -f data/archlinux-latest.conf
  iso=$(cd data && ls archlinux-latest/archlinux-*.iso | tail -1)
  ln -sfn "$iso" data/archlinux.iso
fi

mkdir -p pacoloco/cache
PACOLOCO_UID=$(id -u) PACOLOCO_GID=$(id -g) docker compose up -d

if [[ -e data/disk.qcow2 ]]; then
  quickemu --vm quickemu.conf --delete-disk
fi
# The live ISO's cloud-init reads this at boot and mounts the repo share and links install.dev.sh into /root.
mkdir -p data/cidata
echo "instance-id: arch-bootstrap-dev" >data/cidata/meta-data
cat >data/cidata/user-data <<EOF
#cloud-config
runcmd:
  - [mount, -m, -t, 9p, Public-${USER,,}, /s]
  - [ln, -s, /s/install.dev.sh, /root/install.dev.sh]
EOF
genisoimage -quiet -output data/cidata.iso -volid cidata -joliet -rock data/cidata/user-data data/cidata/meta-data

trap 'quickemu --vm quickemu.conf --kill >/dev/null 2>&1 || true' EXIT
quickemu --vm quickemu.conf --public-dir "$PWD"

cat <<EOF

In the live ISO, run:

  ./install.dev.sh

EOF

while kill -0 "$(cat data/quickemu.pid 2>/dev/null)" 2>/dev/null; do
  sleep 1
done
