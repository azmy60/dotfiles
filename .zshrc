# Starts zsh's completion itself, so it must come first and replace compinit.
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups

eval "$(mise activate zsh)"

# start-hyprland restarts Hyprland if it crashes, and wraps it in nixGL since it comes from nix.
alias start='start-hyprland'
alias ls='eza'
alias vim='nvim'
# nix-setup disables itself once the nix packages are installed.
if [[ -o login && -z $WAYLAND_DISPLAY ]]; then
  if systemctl is-enabled --quiet nix-setup 2>/dev/null; then
    case $(systemctl show -p ActiveState --value nix-setup) in
      activating) echo "Not ready yet: Hyprland and the nix packages are still installing. Follow with: journalctl -u nix-setup -f" ;;
      failed) echo "Installing the nix packages failed. See: journalctl -u nix-setup" ;;
      *) echo "Not ready yet: the nix packages haven't installed. Start now with: sudo systemctl start nix-setup" ;;
    esac
  else
    echo "Type 'start' to launch Hyprland."
  fi
fi

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Must be sourced last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
