export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/app/bin/:$PATH"
export PATH="$HOME/app/:$PATH"
export PATH="$HOME/.local/bin:$PATH"

alias vim=nvim
alias ls=exa
alias tt=toggle-transparency
