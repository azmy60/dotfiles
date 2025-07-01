#!/usr/bin/env bash

set -e

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "${CYAN}> Dotfiles Setup (Tested on Linux Mint)${RESET}"
echo "${CYAN}> This script will:${RESET}"
echo "${CYAN}>   - Symlink .tmux.conf and .config folders${RESET}"
echo "${CYAN}>   - Update ~/.bashrc to source project .bashrc${RESET}"
echo "${CYAN}>   - Install snapd if missing${RESET}"
echo "${CYAN}>   - Install AwesomeWM if missing${RESET}"
echo "${CYAN}>   - Install Neovim manually to /opt/nvim${RESET}"
echo "${CYAN}>   - Install Rust/Cargo and Alacritty${RESET}"
echo "${CYAN}> Continue? (y/n)${RESET}"

read -r -p "> " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "${YELLOW}! Aborted by user.${RESET}"
  exit 1
fi

# Ask for sudo password upfront
echo "${CYAN}> Requesting sudo permissions upfront...${RESET}"
sudo -v

echo "${CYAN}> Starting setup...${RESET}"

# ---- 0. Ensure snapd is installed ----
echo "${CYAN}> Checking for Snap${RESET}"
if ! command -v snap &>/dev/null; then
  echo "${YELLOW}! Snap not found. Installing snapd...${RESET}"
  sudo apt update
  sudo apt install snapd -y
  echo "${GREEN}✔ snapd installed${RESET}"
else
  echo "${GREEN}✔ snapd is already installed${RESET}"
fi

# ---- 0b. Install AwesomeWM ----
echo "${CYAN}> Checking for AwesomeWM${RESET}"
if ! command -v awesome &>/dev/null; then
  echo "${YELLOW}! AwesomeWM not found. Installing AwesomeWM...${RESET}"
  sudo apt update
  sudo apt install awesome -y
  echo "${GREEN}✔ AwesomeWM installed${RESET}"
else
  echo "${GREEN}✔ AwesomeWM is already installed${RESET}"
fi

# ---- 1. Link .tmux.conf ----
echo "${CYAN}> Checking ~/.tmux.conf${RESET}"
if [ -e "$HOME/.tmux.conf" ]; then
  echo "${YELLOW}! ~/.tmux.conf exists — skipping${RESET}"
else
  ln -s "$PROJECT_DIR/.tmux.conf" "$HOME/.tmux.conf"
  echo "${GREEN}✔ Linked ~/.tmux.conf -> project version${RESET}"
fi

# ---- 2. Link .config folders ----
echo "${CYAN}> Linking .config folders${RESET}"
mkdir -p "$HOME/.config"

CONFLICTS=()

for dir in "$PROJECT_DIR/.config/"*/; do
  folder=$(basename "$dir")
  TARGET="$HOME/.config/$folder"
  SOURCE="$dir"

  if [ -e "$TARGET" ]; then
    CONFLICTS+=("$folder")
    echo "${YELLOW}! $folder exists — skipping${RESET}"
  else
    ln -s "$SOURCE" "$TARGET"
    echo "${GREEN}✔ Linked $folder${RESET}"
  fi
done

if [ ${#CONFLICTS[@]} -gt 0 ]; then
  echo "${YELLOW}! The following folders already exist:${RESET}"
  for c in "${CONFLICTS[@]}"; do
    echo "${YELLOW}  - $c${RESET}"
  done
  echo "${YELLOW}! Please handle these manually if needed.${RESET}"
fi

# ---- 3. Append source to .bashrc ----
echo "${CYAN}> Checking ~/.bashrc for project source${RESET}"
BASHRC_LINE="source \"$PROJECT_DIR/.bashrc\""

if grep -Fxq "$BASHRC_LINE" "$HOME/.bashrc"; then
  echo "${YELLOW}! Already sourced — skipping${RESET}"
else
  echo "" >> "$HOME/.bashrc"
  echo "# Load custom dotfiles bashrc" >> "$HOME/.bashrc"
  echo "$BASHRC_LINE" >> "$HOME/.bashrc"
  echo "${GREEN}✔ Added source line${RESET}"
fi

# ---- 4. Install latest Neovim ----
echo "${CYAN}> Installing latest Neovim manually${RESET}"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
echo "${GREEN}✔ Neovim installed to /opt/nvim${RESET}"

# ---- 5. Install Rust & Cargo ----
echo "${CYAN}> Installing Rust and Cargo${RESET}"
if command -v cargo &>/dev/null; then
  echo "${YELLOW}! Cargo already installed — skipping${RESET}"
else
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  echo "${GREEN}✔ Rust and Cargo installed${RESET}"
fi

# ---- 6. Install Alacritty ----
echo "${CYAN}> Installing Alacritty with Cargo${RESET}"
source "$HOME/.cargo/env"
if command -v alacritty &>/dev/null; then
  echo "${YELLOW}! Alacritty already installed — skipping${RESET}"
else
  cargo install alacritty
  echo "${GREEN}✔ Alacritty installed${RESET}"
fi

# ---- 7. Install tmux ----
echo "${CYAN}> Installing latest tmux ${RESET}"
sudo apt install tmux -y
echo "${GREEN}✔ Latest tmux installed${RESET}"

# ---- 8. Install lua ----
echo "${CYAN}> Installing lua ${RESET}"
sudo apt install lua5.4 -y
echo "${GREEN}✔ Lua installed${RESET}"

# ---- 9. Install compton ----
echo "${CYAN}> Installing compton for transparency effect${RESET}"
sudo apt install compton -y
echo "${GREEN}✔ compton installed${RESET}"

# ---- 10. Install nitrogen ----
echo "${CYAN}> Installing nitrogen for awesomewm bg${RESET}"
sudo apt install introgen -y
echo "${GREEN}✔ nitrogen installed${RESET}"

# ---- 10. Install eza ----
echo "${CYAN}> Installing eza for ls replacement${RESET}"
sudo apt install eza -y
echo "${GREEN}✔ eza installed${RESET}"

echo "${CYAN}> Setup complete! Open a new terminal or run: source ~/.bashrc${RESET}"

