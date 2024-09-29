#!/bin/bash

# stop if this is not an interactive shell
[[ $- != *i* ]] && return

export BASH_CONFIG_PATH="$HOME/.config/bash"
export SHELL_CONFIG_PATH="$HOME/.config/shell"

set -o allexport
source $SHELL_CONFIG_PATH/functions.sh

source $SHELL_CONFIG_PATH/environment.sh

source $BASH_CONFIG_PATH/environment.sh
set +o allexport

source $SHELL_CONFIG_PATH/alias.sh

source $SHELL_CONFIG_PATH/keymaps.sh

source $BASH_CONFIG_PATH/readline.sh

source $BASH_CONFIG_PATH/prompt.sh

test -f "$HOME/.bash-completion/bash_completion" && . $_

test -f "$HOME/$GIT_CONFIG_PATH/git-completion.bash" && . $_

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
