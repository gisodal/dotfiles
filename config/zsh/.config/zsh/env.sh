#!/bin/zsh

# default apps
export TERMINAL="alacritty"
export BROWSER="google-chrome-stable"

# setup fzf
if command -v fzf 2>/dev/null 1>&2; then
	source <(fzf --zsh)

	# Fix fzf key bindings for zsh-vi-mode
	function zvm_after_init() {
		bindkey '^R' fzf-history-widget
		bindkey '^T' fzf-file-widget
		bindkey '\ec' fzf-cd-widget
	}
fi

if exists mise; then 
  eval "$(mise activate zsh)"
fi
