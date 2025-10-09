#!/bin/bash

# stop if this is not an interactive shell
[[ $- != *i* ]] && return

export BASH_CONFIG_PATH="$HOME/.config/bash"
export SHELL_CONFIG_PATH="$HOME/.config/shell"

if [ ! -d $SHELL_CONFIG_PATH ]; then
  echo "Could not find shell configuration: ${SHELL_CONFIG_PATH}" 1>&2
  return 0
fi

if [ ! -d $BASH_CONFIG_PATH ]; then
  echo "Could not find bash configuration: ${BASH_CONFIG_PATH}" 1>&2
  return 0
fi

set -o allexport
source $SHELL_CONFIG_PATH/functions.sh

source $SHELL_CONFIG_PATH/env.sh

source $BASH_CONFIG_PATH/env.sh

[ -f $HOME/.env ] && source $HOME/.env
set +o allexport

source $SHELL_CONFIG_PATH/alias.sh

source $SHELL_CONFIG_PATH/keymaps.sh

source $BASH_CONFIG_PATH/readline.sh

source $BASH_CONFIG_PATH/prompt.sh

test -f "/etc/bash_completion" && . $_

test -f "$HOME/$GIT_CONFIG_PATH/git-completion.bash" && . $_

if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash

if [ -z "$TMUX" ] && command -v tmux &>/dev/null; then
  tmux attach 2>/dev/null || tmux
fi
