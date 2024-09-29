#!/bin/bash

[ -n "$BASH_CUSTOM_ENVIRONMENT" ] && return
BASH_CUSTOM_ENVIRONMENT="set"

# setup direnv if it is available
if exists direnv; then
  eval "$(direnv hook bash)"
fi
