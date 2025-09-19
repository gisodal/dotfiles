#!/bin/bash

# this file is called for login shells. .bashrc is called for non-login shells.

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
