#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if curl -fsS -o /dev/null http://localhost:8000 2>/dev/null; then
  echo "Port 8000 is already in use." >&2
  exit 1
fi

mkdir -p data
if [[ ! -e data/archlinux.iso ]]; then
  (cd data && quickget archlinux latest)
  rm -f data/archlinux-latest.conf
  iso=$(cd data && ls archlinux-latest/archlinux-*.iso | tail -1)
  ln -sfn "$iso" data/archlinux.iso
fi

mkdir -p pacoloco/cache
PACOLOCO_UID=$(id -u) PACOLOCO_GID=$(id -g) docker compose up -d

python3 -m http.server 8000 --bind 127.0.0.1 -d . &
server=$!
trap 'kill $server 2>/dev/null || true' EXIT

until curl -fsS -o /dev/null http://localhost:8000/install.sh 2>/dev/null; do
  if ! kill -0 $server 2>/dev/null; then
    exit 1
  fi
  sleep 0.1
done

echo "Ready!"
wait $server
