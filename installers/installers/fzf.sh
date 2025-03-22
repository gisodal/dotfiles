#!/bin/bash

XDG_OPT_HOME="$HOME/.local/opt"
mkdir -p "$XDG_OPT_HOME"

git clone --depth 1 https://github.com/junegunn/fzf.git "$XDG_OPT_HOME/fzf"

$XDG_OPT_HOME/fzf/install --key-bindings --completion --no-update-rc --xdg
