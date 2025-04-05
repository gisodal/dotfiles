#!/bin/bash

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

exists fdfind && alias fd='fdfind'

alias grep='grep --line-number --color=auto'
alias tmux='tmux -2 -u'                      # force 256 colors AND UTF-8
alias xcopy='xclip -selectionclipboard'      # copy to clipboard
alias xpaste='xclip -selection clipboard -o' # paste from clipboard
alias sshnokey='ssh -Y -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias ..='popd &>/dev/null'
alias vim='vim -O'
alias vimdiff='vim -d -c "norm ]c[c"' # jump to first difference on startup
alias d='nvim -d -c "norm ]c[c"' # jump to first difference on startup
alias unspoof='spoof x'
alias vgdb='valgrind --vgdb=yes --vgdb-error=0 --leak-check=full --show-reachable=yes --track-origins=yes --num-callers=20 --track-fds=yes -s'
alias evince='env -i DISPLAY=$DISPLAY evince'
alias lock='lxlock' # sudo apt-get install lxsession
alias callgrind='valgrind --tool=callgrind'
alias profgrind='valgrind --tool=kcachegrind'
alias blank='sleep 1; xset dpms force off'
alias suspend='systemctl suspend'
alias k='fc -s'
alias ports='netstat -tulpn'
alias rg='rg --hidden --smart-case --column --follow --glob="!**/.git/*"'
