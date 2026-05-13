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
alias vimch="cd ~/projects/clickhouse_migrations/ && vim"
alias vimpg="cd ~/projects/postgres_migrations/ && vim"
alias cal='ncal -b'
alias ip='ip --color=auto'
alias update='sudo apt update && sudo apt upgrade -y && brew update && brew upgrade && pipx upgrade-all && omz update'
alias moonlight='flatpak run com.moonlight_stream.Moonlight stream boba Desktop'
alias organicmaps='flatpak run app.organicmaps.desktop'

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
export PATH="$PATH:/home/$USER/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Auto-start X on tty1
if [[ -z "$DISPLAY" && "$XDG_VTNR" == "1" ]]; then
  exec startx
fi
