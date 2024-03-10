alias ls="command ls --color=auto -v -h --group-directories-first -a -I .. -I . -I .git"
alias vim='vim -O'
alias vimdiff='vim -d -c "norm ]c[c"' # jump to first difference on startup
alias tmux='tmux -2 -u'                        # force 256 colors AND UTF-8
alias grep='grep --line-number --color=auto'
alias lf='lfcd'
alias cd='f() { c\d $1 && ls };f'
