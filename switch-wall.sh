#!/bin/bash

WALLS_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="$HOME/.cache/last_wallpaper.txt"

# Default
SKIP_ANIM=false

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-animation|-s)
            SKIP_ANIM=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

shopt -s nullglob
walls=("$WALLS_DIR"/*.jpg "$WALLS_DIR"/*.png)

if [[ ${#walls[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLS_DIR"
    exit 1
fi

# Read the last wallpaper (if it exists)
last=""
if [[ -f "$STATE_FILE" ]]; then
    last=$(<"$STATE_FILE")
fi

# Pick a random wallpaper that's not the same as last
while : ; do
    wall="${walls[RANDOM % ${#walls[@]}]}"
    if [[ "$wall" != "$last" ]]; then
        break
    fi
    # If only one wallpaper, avoid infinite loop
    if [[ ${#walls[@]} -le 1 ]]; then
        break
    fi
done

# Save the chosen wallpaper
echo "$wall" >"$STATE_FILE"

# Set wallpaper using awww
if $SKIP_ANIM; then
    awww img "$wall" --transition-type none
else
    awww img "$wall"
fi
