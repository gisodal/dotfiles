#!/bin/bash

# stop if this is not an interactive shell
[[ $- != *i* ]] && return

export BASH_CONFIG_HOME="$HOME/.config/bash"
export SHELL_CONFIG_HOME="$HOME/.config/shell"

source $SHELL_CONFIG_HOME/functions.sh

source $SHELL_CONFIG_HOME/environment.sh

source $BASH_CONFIG_HOME/environment.sh

source $SHELL_CONFIG_HOME/alias.sh

source $SHELL_CONFIG_HOME/keymaps.sh

source $BASH_CONFIG_HOME/readline.sh

source $BASH_CONFIG_HOME/prompt.sh

test -f "$HOME/.bash-completion/bash_completion" && . $_

test -f "$HOME/$GIT_CONFIG_DIR/git-completion.bash" && . $_

if [ -f $HOME/.bash_local ]; then
  source $HOME/.bash_local
fi

if [ -z "$SSH_TTY" ] &&
  [ -z "$SSH_CONNECTION" ] &&
  [ -z "$SSH_CLIENT" ] &&
  [ -n "$DISPLAY" ] &&
  [ -z "$TMUX" ]; then
  tmux
fi

