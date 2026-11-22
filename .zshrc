# Starts zsh's completion itself, so it must come first and replace compinit.
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups

export PATH="$HOME/.local/bin:$PATH"

eval "$(mise activate zsh)"

# start-hyprland restarts Hyprland if it crashes, and wraps it in nixGL since it comes from nix.
alias start='start-hyprland'
alias ls='eza'
alias vim='nvim'
if [[ -o login && -z $WAYLAND_DISPLAY ]]; then
  if systemctl is-failed --quiet nix-setup; then
    echo "Installing the nix packages failed. See: journalctl -u nix-setup"
  else
    echo "Type 'start' to launch Hyprland."
  fi
  if systemctl is-failed --quiet llama-setup; then
    echo "Installing llama failed. See: journalctl -u llama-setup"
  fi
fi

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Must be sourced last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ai-completion="HIP_VISIBLE_DEVICES=0 llama serve \
  --hf-repo ggml-org/Qwen2.5-Coder-1.5B-IQ3_XXS-GGUF --hf-file qwen2.5-coder-1.5b-iq3_xxs-imat.gguf \
  --host 0.0.0.0 --port 8012 -ngl 99 -fa on -dt 0.1 \
  --ubatch-size 512 --batch-size 1024 \
  --ctx-size 0 --cache-reuse 256"
