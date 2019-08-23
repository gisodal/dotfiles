#!/bin/bash

if [ -f "$HOME/.bash_environment" ]; then
    . "$HOME/.bash_environment"
fi

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

if [ -f "$HOME/.git-completion.bash" ]; then
    . "$HOME/.git-completion.bash"
fi

