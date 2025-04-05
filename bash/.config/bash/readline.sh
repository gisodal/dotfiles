#!/bin/bash

# -----------------------------------------------------------------------------
# Change (shell) readline bindings and settings
# -----------------------------------------------------------------------------

#bind C-k:previous-history
#bind C-j:next-history
#
#bind C-l:forward-char
#bind C-h:backward-char
#
#bind C-e:beginning-of-line
#bind C-r:end-of-line
#
#bind C-y:history-search-backward
#bind C-t:history-search-forward
#
#bind C-u:backward-delete-char
#bind C-o:delete-char
#
#bind C-n:kill-whole-line
#bind C-d:
#bind C-s:
#

# vi mode
bind "set editing-mode vi"
bind "set show-mode-in-prompt on"        # show insert mode
bind "set vi-ins-mode-string \1\e[6 q\2" # line cursor
bind "set vi-cmd-mode-string \1\e[2 q\2" # block cursor

# optionally:
# switch to block cursor before executing a command
bind "set keymap vi-insert"
bind "RETURN: \"\e\n\""

bind "set completion-ignore-case     on"
bind "set expand-tilde               off"
bind "set show-all-if-ambiguous      on"
bind "set show-all-if-unmodified     on"
bind "set mark-symlinked-directories on" #  append  /  to  symlinked  directories  on  autocomplete
#bind "set completion-query-items     0"

# list standard key bindings:
# > stty -a
#if [ -t 0 ]; then # only run if stdin is a terminal
#  stty kill undef # unset ctrl-u to make it backspace with ~/.inputrc
#  # stty kill ^Q
#  stty -ixon # turn off flow control (Ctrl-s: stop & Ctrl-Q: continue)
#fi

shopt -s cmdhist      # Bash attempts to save all lines of a multiple-line command in the same history entry.
shopt -s lithist      # history newlines rather than semicolons
shopt -s histappend   # the history list is appended to the file named by the value of the HISTFILE variable when the shell exits, rather than overwriting the file.
shopt -s cdspell      # correct minor spell errors while using cdspell
shopt -s dirspell     # Bash attempts spelling correction on directory names during word completion if the directory name initially supplied does not exist.
shopt -s dotglob      # include hidden files with cp, mv, etc.
shopt -s checkwinsize # check window size after each command
shopt -s nocaseglob   # Bash matches filenames in a case-insensitive fashion when performing filename expansion.
