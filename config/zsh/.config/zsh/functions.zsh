#!/bin/zsh



# Bind it to Ctrl+n (You can change '^n' to whatever you like)
#bindkey '^n' fzf-nx-widget
# Bind to Ctrl+o in both Insert and Command modes
# This will NOT touch your Ctrl+n (down) binding
bindkey -M viins '^o' fzf-nx-widget
bindkey -M vicmd '^o' fzf-nx-widget
