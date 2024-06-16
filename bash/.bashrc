#!/bin/bash

case "$-" in
    *i*) # shell is interactive

        source $HOME/.bash_map

        source $HOME/.bash_environment

        source $HOME/.bash_alias

        source $HOME/.bash_functions

        source $HOME/.bash_terminal

        source $HOME/.bash_prompt

        test -f "$HOME/.bash-completion/bash_completion" && . $_

        test -f "$HOME/$GIT_CONFIG_DIR/git-completion.bash" && . $_

        if [ -f $HOME/.bash_local ]; then
            source $HOME/.bash_local
        fi

        if  [ -z "$SSH_TTY" ]           && \
            [ -z "$SSH_CONNECTION" ]    && \
            [ -z "$SSH_CLIENT" ]        && \
            [ -n "$DISPLAY" ]           && \
            [ -z "$TMUX"  ]; then
            tmux
        fi

        ;;
    *) # shell is not interactive
    ;;
esac


# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
