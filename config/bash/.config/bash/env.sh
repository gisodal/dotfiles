#!/bin/bash

# setup direnv if it is available
if exists direnv; then
  eval "$(direnv hook bash)"
fi

if exists mise; then
  eval "$(mise activate zsh)"
fi

# setup fzf
if exists fzf; then
  eval "$(fzf --bash)"
fi

[ -n "$BASH_CUSTOM_ENVIRONMENT" ] && return
BASH_CUSTOM_ENVIRONMENT="set"

# don't reload below this line
