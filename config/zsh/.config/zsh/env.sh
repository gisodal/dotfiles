#!/bin/zsh

# default apps
export TERMINAL="alacritty"
export BROWSER="google-chrome-stable"

# setup fzf
if command -v fzf 2>/dev/null 1>&2; then
	source <(fzf --zsh)

	# Fix fzf key bindings for zsh-vi-mode
	function zvm_after_init() {
		[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
		# Restore fzf key bindings
		bindkey '^R' fzf-history-widget
		bindkey '^T' fzf-file-widget
		bindkey '\ec' fzf-cd-widget
	}
fi

#setup direnv if it is available
if exists direnv; then
  eval "$(direnv hook zsh)"
fi
