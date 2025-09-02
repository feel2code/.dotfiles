# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fino"
plugins=(git)

source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias :q="exit"
alias py="ipython"
alias db="bash ~/db_cli_tools/db.sh"
alias gs="git for-each-ref --format=' %(authorname) %09 %(refname)' --sort=authorname"
alias vimdags="cd ~/projects/dags/ && source venv/bin/activate && vim"
alias vimch="cd ~/projects/clickhouse-migrations/ && vim"
alias vimpg="cd ~/projects/postgresql-migrations/ && vim"
alias saas="cd ~/projects/saas/"

# vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char

export PATH=$PATH:/opt/nvim/bin/
export PATH=$PATH:~/.cargo/bin/
export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2025-04-15 06:31:23
export PATH="$PATH:/home/feliks/.local/bin"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# open tmux session on each kitty terminal
if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
  tmux attach || exec tmux new-session -s dev && exit;
fi
