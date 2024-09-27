#!/bin/bash

[ -n "$BASH_CUSTOM_ENVIRONMENT" ] && return

# setup direnv if it is available
if exists direnv; then
  eval "$(direnv hook bash)"
fi

export BASH_CUSTOM_ENVIRONMENT="set"
