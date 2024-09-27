#!/bin/bash

# -----------------------------------------------------------------------------
# Key mapping
# -----------------------------------------------------------------------------

alias nomap='setxkbmap -option;'
alias freestyle='xkbcomp -w0 -I"$HOME/.xkb" "$HOME/.xkb/keymap/myfreestylekbd" "$DISPLAY"'
#alias swapcaps='setxkbmap -option; setxkbmap -layout us; setxkbmap -option ctrl:swapcaps -option terminate:ctrl_alt_bksp'
alias swapcaps='xkbcomp -w0 -I"$HOME/.xkb" "$HOME/.xkb/keymap/mykbd" "$DISPLAY"'
alias disable-mouseacceleration='xset m 00'
alias kd='disable-mouseacceleration; kbd'


# reset keymap:
# > setxkbmap -option

# create custom layout:
# 1) create layout with setxkbmap, e.g.:
#    > setxkbmap -layout us -option ctrl:swapcaps -option terminate:ctrl_alt_bksp
# 2) make keymap file from current layout:
#    > mkdir -p $HOME/.xkb/keymap
#    > setxkbmap -print > $HOME/.xkb/keymap/<filename>
# 3) load custom keymap file:
#    > xkbcomp -w0 -I"$HOME/.xkb" "$HOME/.xkb/keymap/<filename>" "$DISPLAY"

# create custom options:
# 1) create symbol file .xkb/symbols/<symbolfile>
# 2) example symbol file at /usr/share/X11/xkb/symbols
# 3) add to xkb_symbols field +<symbolfile>(<xkb_symbols name>)
