PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/app/bin"
export PATH="$PATH:$HOME/app"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export PYTHONPATH=$PYTHONPATH:$HOME/.pyenv/versions/3.11.5/bin

export SYSTEMD_EDITOR=nvim

alias vim=nvim
alias ls=eza
alias tt=toggle-transparency
alias wifi=$HOME/dotfiles/wifi.sh
alias vimdiff="nvim -d"
alias ai="source $PROJECT_DIR/ai/run.sh"
alias what="ai what"
alias how="ai how"
alias i="ai i"
alias roblox="flatpak run org.vinegarhq.Sober"
alias ai-completion="llama-server \
  --hf-repo ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF --hf-file qwen2.5-coder-3b-q8_0.gguf \
  --port 8012 -ngl 99 -fa on -dt 0.1 \
  --ubatch-size 512 --batch-size 1024 \
  --ctx-size 0 --cache-reuse 256"
