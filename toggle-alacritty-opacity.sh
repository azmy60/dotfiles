#!/bin/bash

CONFIG="$HOME/.config/alacritty/alacritty.toml"

# Read current opacity (cut everything except the number)
current=$(grep -m1 "opacity" "$CONFIG" | sed 's/[^0-9.]//g')

if [[ -z "$current" ]]; then
    current=1.0
fi

change="$1" # this will be +0.1 or -0.1

new=$(awk -v c="$current" -v d="$change" 'BEGIN { 
    n = c + d; 
    if (n < 0.1) n = 0.1; 
    if (n > 1.0) n = 1.0; 
    printf "%.1f", n 
}')

# Replace the opacity value in the file
sed -i "s/opacit.*/opacity = $new/" "$CONFIG"
