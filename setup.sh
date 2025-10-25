#!/usr/bin/env bash
set -e

# --- Color Setup ---
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

# --- Paths ---
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$PROJECT_DIR/setup.sh.log"

# --- Timestamp Logging ---
timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

# --- Dual Output Logging ---
log_info() {
  echo -e "${CYAN}> $*${RESET}"
  echo "$(timestamp) > $*" >> "$LOG_FILE"
}
log_success() {
  echo -e "${GREEN}✔ $*${RESET}"
  echo "$(timestamp) ✔ $*" >> "$LOG_FILE"
}
log_warn() {
  echo -e "${YELLOW}! $*${RESET}"
  echo "$(timestamp) ! $*" >> "$LOG_FILE"
}

# --- Help Message (default) ---
if [[ "$1" != "run" ]]; then
    cat <<EOF

██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗██╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝██║
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗██║
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║╚═╝
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║██╗
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚═╝
                                                                
This script installs and configures the following:

EOF

  if [[ "$1" == "what" || "$1" == "whatplsimbegginghelpcomeonpls" ]]; then
    cat <<EOF
- ${CYAN}.tmux.conf & .config${RESET} my dotfiles (tmux, nvim, etc)
- ${CYAN}~/.bashrc${RESET}            adds source line to project bashrc
- ${CYAN}flatpak${RESET}              needed for some packages
- ${CYAN}AwesomeWM${RESET}            tiling WM
- ${CYAN}Neovim${RESET}               installed manually to /opt/nvim
- ${CYAN}Rust & Cargo${RESET}         needed to build Alacritty
- ${CYAN}Alacritty${RESET}            terminal I like
- ${CYAN}tmux${RESET}                 you know :)
- ${CYAN}lua${RESET}                  used by awesome/nvim
- ${CYAN}picom${RESET}                transparency/shadows
- ${CYAN}nitrogen${RESET}             wallpaper setter
- ${CYAN}eza${RESET}                  better ls
- ${CYAN}caffeine${RESET}             keep the monitor on while program fullscreen

EOF
  else
    cat <<EOF
- ${CYAN}~/.bashrc${RESET}, ${CYAN}.tmux.conf${RESET} & ${CYAN}.config${RESET} files & folders
- ${CYAN}flatpak${RESET}, ${CYAN}AwesomeWM${RESET}, ${CYAN}Neovim${RESET}, ${CYAN}Rust${RESET}, ${CYAN}Cargo${RESET}, ${CYAN}Alacritty${RESET},
  ${CYAN}tmux${RESET}, ${CYAN}lua${RESET}, ${CYAN}picom${RESET}, ${CYAN}nitrogen${RESET}, ${CYAN}eza${RESET}, ${CYAN}caffeine${RESET}

EOF
  fi

  cat <<EOF
Usage:
  ./setup.sh run            Run the setup
  ./setup.sh                Show this help message
  ./setup.sh what           Show what the heck the above are
  ./setup.sh whatplsimbegginghelpcomeonpls

EOF
  if [[ "$1" == "whatplsimbegginghelpcomeonpls" ]]; then
    echo "damn.. slow down next time aight? we cool tho :)"
  fi
  exit 0
fi

log_info "----- Setup started -----"
log_info "Requesting sudo permissions upfront..."
sudo -v

log_info "Starting setup..."

# ---- 0. flatpak ----
log_info "Checking for flatpak"
if ! command -v flatpak &>/dev/null; then
  log_warn "flatpak not found. Installing..."
  sudo apt-get update
  sudo apt-get install flatpak gnome-software-plugin-flatpak -y
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  log_success "flatpak installed"
else
  log_success "flatpak is already installed"
fi

# ---- 0b. Window Manager ----
if command -v xrandr &>/dev/null; then
  log_info "Checking for AwesomeWM"
  if ! command -v awesome &>/dev/null; then
    log_warn "AwesomeWM not found. Installing..."
    sudo apt-get install awesome -y
    log_success "AwesomeWM installed"
  else
    log_success "AwesomeWM is already installed"
  fi
else
  log_warn "Skipping AwesomeWM — no GUI detected"
fi

# ---- 1. .tmux.conf ----
log_info "Checking ~/.tmux.conf"
if [ -e "$HOME/.tmux.conf" ]; then
  log_warn "~/.tmux.conf exists — skipping"
else
  ln -s "$PROJECT_DIR/.tmux.conf" "$HOME/.tmux.conf"
  log_success "Linked ~/.tmux.conf"
fi

# ---- 2. .config folders ----
log_info "Linking .config folders"
mkdir -p "$HOME/.config"
CONFLICTS=()
for dir in "$PROJECT_DIR/.config/"*/; do
  folder=$(basename "$dir")
  TARGET="$HOME/.config/$folder"
  SOURCE="$dir"

  if [ -e "$TARGET" ]; then
    CONFLICTS+=("$folder")
    log_warn "$folder exists — skipping"
  else
    ln -s "$SOURCE" "$TARGET"
    log_success "Linked $folder"
  fi
done
if [ ${#CONFLICTS[@]} -gt 0 ]; then
  log_warn "These folders already exist:"
  for c in "${CONFLICTS[@]}"; do
    log_warn "  - $c"
  done
fi

# ---- 2b. .config files ----
log_info "Linking .config files"
for file in "$PROJECT_DIR/.config/"*; do
  [ -d "$file" ] && continue
  filename=$(basename "$file")
  TARGET="$HOME/.config/$filename"
  SOURCE="$file"

  if [ -e "$TARGET" ]; then
    log_warn "$filename exists — skipping"
  else
    ln -s "$SOURCE" "$TARGET"
    log_success "Linked $filename"
  fi
done

# ---- 3. .bashrc ----
log_info "Checking ~/.bashrc for project source"
BASHRC_LINE="source \"$PROJECT_DIR/.bashrc\""
if grep -Fxq "$BASHRC_LINE" "$HOME/.bashrc"; then
  log_warn "Already sourced — skipping"
else
  echo "" >> "$HOME/.bashrc"
  echo "# Load custom dotfiles bashrc" >> "$HOME/.bashrc"
  echo "$BASHRC_LINE" >> "$HOME/.bashrc"
  log_success "Added source line"
fi

# ---- 4. Neovim ----
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
log_warn "Installing/updating Neovim..."
curl -LO "$NEOVIM_URL"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
log_success "Neovim installed"

# ---- 5. Rust/Cargo ----
log_info "Checking Rust/Cargo"
if ! command -v rustup &>/dev/null; then
  log_warn "Rustup not found. Installing..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
else
  rustup update
fi
log_success "Rust/Cargo ready"

# ---- 6. Alacritty ----
log_info "Checking Alacritty"
source "$HOME/.cargo/env"
if command -v alacritty &>/dev/null; then
  log_warn "Alacritty already installed — skipping"
else
  cargo install alacritty
  log_success "Alacritty installed"
fi

# ---- 7. Tmux ----
log_info "Installing/upgrading tmux"
sudo apt-get install tmux -y
log_success "tmux installed"

# ---- 8. Lua ----
log_info "Installing/upgrading Lua"
sudo apt-get install lua5.4 -y
log_success "Lua installed"

# ---- 9. Compositor ----
log_info "Installing/upgrading picom"
sudo apt-get install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev
sudo apt-get install picom -y
log_success "picom installed"

# ---- 10. Wallpaper manager ----
log_info "Installing/upgrading nitrogen"
sudo apt-get install nitrogen -y
log_success "nitrogen installed"

# ---- 11. eza ----
log_info "Installing/upgrading eza"
if ! command -v eza &>/dev/null; then
  sudo apt-get install eza -y || cargo install eza
  log_success "eza installed"
else
  log_success "eza already installed"
fi

# ---- 12. Caffeine ----
log_info "Installing/upgrading caffeine"
sudo apt-get install caffeine -y
log_success "caffeine installed"

# ---- 13. chmod ./ai.sh ----
log_info "chmodding ./ai.sh"
chmod +x "$PROJECT_DIR/ai.sh"
log_success "chmodded ./ai.sh. Try running \"ai hey what's up\""

log_info "----- Setup completed -----"
echo "${CYAN}> Setup complete! Open a new terminal or run: source ~/.bashrc${RESET}"
echo "${CYAN}> Log saved to: $LOG_FILE${RESET}"
cat <<EOF

 ██████╗ ██╗  ██╗██╗   ██╗███████╗ █████╗ ██╗  ██╗██╗██╗
██╔═══██╗██║  ██║╚██╗ ██╔╝██╔════╝██╔══██╗██║  ██║██║██║
██║   ██║███████║ ╚████╔╝ █████╗  ███████║███████║██║██║
██║   ██║██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██║██╔══██║╚═╝╚═╝
╚██████╔╝██║  ██║   ██║   ███████╗██║  ██║██║  ██║██╗██╗
 ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝

EOF
