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
if [[ -o login && -z $WAYLAND_DISPLAY ]]; then
  echo "Type 'start' to launch Hyprland."
fi

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Must be sourced last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
