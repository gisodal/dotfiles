alias tmux='tmux -2 -u'                        # force 256 colors AND UTF-8
alias lf='lfcd'
alias drive='(){ [ ! -d "$1" ] && mkdir -p $1 && rclone --vfs-cache-mode writes mount "gdrive": ${1} && rm -r "$1" }'
alias vim='nvim'
alias vimdiff='nvim -d -c "norm ]c[c"' # jump to first difference on startup
alias md=ghostwriter

if [ `command -v "eza"` ]; then
    alias ls='eza --icons --git --time-style=long-iso --group-directories-first -a'
else
  echo no
	alias ls='ls -A --color=auto' # --group-directories-first'
fi

alias top='btop'
alias du='duf'
alias df='dust'
alias http='xh'
alias cat='bat'
alias cd='() { cd $@ && ls }'

