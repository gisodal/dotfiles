#!/bin/bash

# -----------------------------------------------------------------------------
# Change (shell) readline bindings and settings
# -----------------------------------------------------------------------------

bind C-k:previous-history
bind C-j:next-history

bind C-l:forward-char
bind C-h:backward-char

bind C-e:beginning-of-line
bind C-r:end-of-line

bind C-y:history-search-backward
bind C-t:history-search-forward

bind C-u:backward-delete-char
bind C-o:delete-char

bind C-n:kill-whole-line
bind C-d:
bind C-s:

bind "set completion-ignore-case     on"
bind "set expand-tilde               off"
bind "set show-all-if-ambiguous      on"
bind "set show-all-if-unmodified     on"
bind "set mark-symlinked-directories on"   #  append  /  to  symlinked  directories  on  autocomplete
bind "set completion-query-items     0"

# list standard key bindings:
# > stty -a
if [ -t 0 ]; then   # only run if stdin is a terminal
    stty kill undef # unset ctrl-u to make it backspace with ~/.inputrc
#    stty kill ^Q
    stty -ixon  # turn off flow control (Ctrl-s: stop & Ctrl-Q: continue)
fi

shopt -s cmdhist                        # make multiline commands stay together
shopt -s lithist                        # history newlines rather than semicolons
shopt -s histappend                     # append to history instead of rewriting
shopt -s cdspell                        # spell check when using cd
shopt -s dotglob                        # include hidden files with cp, mv, etc.
shopt -s checkwinsize                   # check window size after each command
