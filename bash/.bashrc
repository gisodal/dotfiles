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

        test -f "$GIT_CONFIG_DIR/git-completion.bash" && . $_

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

