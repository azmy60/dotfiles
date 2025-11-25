if [[ $(tty) == /dev/tty* ]]; then
  clear
  echo "Custom commands:"
  echo "  start - Launch Hyprland session"
  echo ""

  start() {
    echo "Starting Hyprland..."
    exec Hyprland
  }
fi
