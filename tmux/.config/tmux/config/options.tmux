## always use zsh :)
#set -g default-shell /bin/zsh
#set -g default-command "zsh"

# Address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0

# Increase scrollback buffer size from 2000 to 50000 lines
set -g history-limit 50000

# Increase tmux messages display duration from 750ms to 4s
set -g display-time 4000

# Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
set -g status-interval 5

# true color support
set -g default-terminal "tmux-256color" # use "${TERM}" for any terminal.
set-option -a terminal-features "xterm*:RGB,alacritty*:RGB,tmux*:RGB"

# to enable apply to any terminal use: 
# set-option -a terminal-features "$TERM:RGB"

# true color support for older tmux versions (i.e., use Tc i.s.o. RGB):
# set-option -sa terminal-overrides ",xterm*:Tc,alacritty*:Tc,tmux*:Tc"

# Focus events enabled for terminals that support them
set -g focus-events on

# Super useful when using "grouped sessions" and multi-monitor setup
setw -g aggressive-resize on
## act like gnu screen

set-option -g status-position top

## set 1 as default first window/pane number
set -g base-index 1
setw -g pane-base-index 1

## no more bell messages
set -g bell-action any
set -g visual-bell off
set -g visual-silence off
#
## activity
set -g monitor-activity on
set -g visual-activity off

#set -sg repeat-time 600                   # increase repeat timeout
set -g  mouse on

## tmux session name
set -g allow-rename on # Allow programs in the pane to change the window name using \ek...\e\\
set -g set-titles on
#set -g set-titles-string '[#H:#S] #W #T' # session name, active program, pane title

setw -g automatic-rename on   # rename window to reflect current program
set -g renumber-windows on    # renumber windows when a window is closed


