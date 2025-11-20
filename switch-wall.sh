#!/bin/bash

# Folder with your wallpapers
WALLS_DIR="$HOME/Pictures/wallpapers"

# Pick a random .png
walls=("$WALLS_DIR"/*.png)
wall="${walls[RANDOM % ${#walls[@]}]}"

# Set wallpaper to your monitor
hyprctl hyprpaper wallpaper DP-1,"$wall"
