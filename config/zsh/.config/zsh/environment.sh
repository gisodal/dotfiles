#!/bin/zsh

# default apps
export TERMINAL="alacritty"
export BROWSER="google-chrome-stable"

# setup fzf
if command -v fzf 2>/dev/null 1>&2; then
	source <(fzf --zsh)
fi

#setup direnv if it is available
if exists direnv; then
  eval "$(direnv hook zsh)"
fi
