alias tmux='tmux -2 -u'                        # force 256 colors AND UTF-8
alias drive='(){ [ ! -d "$1" ] && mkdir -p $1 && rclone --vfs-cache-mode writes mount "gdrive": ${1} && rm -r "$1" }'
alias md=ghostwriter

alias top='btop'
alias du='duf'
alias df='dust'
alias http='xh'
alias cat='bat'

