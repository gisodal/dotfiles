#!/bin/bash

# stop if this is not an interactive shell
[[ $- != *i* ]] && return

export BASH_CONFIG_DIR="$HOME/.config/bash"
export SHELL_CONFIG_DIR="$HOME/.config/shell"

set -o allexport
source $SHELL_CONFIG_DIR/functions.sh

source $SHELL_CONFIG_DIR/environment.sh

source $BASH_CONFIG_DIR/environment.sh
set +o allexport

source $SHELL_CONFIG_DIR/alias.sh

source $SHELL_CONFIG_DIR/keymaps.sh

source $BASH_CONFIG_DIR/readline.sh

source $BASH_CONFIG_DIR/prompt.sh

test -f "$HOME/.bash-completion/bash_completion" && . $_

test -f "$HOME/$GIT_CONFIG_DIR/git-completion.bash" && . $_

if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi

if [ -z "$SSH_TTY" ] &&
  [ -z "$SSH_CONNECTION" ] &&
  [ -z "$SSH_CLIENT" ] &&
  [ -n "$DISPLAY" ] &&
  [ -z "$TMUX" ]; then
  tmux
fi
