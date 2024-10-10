# .zshrc location
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# default apps
export TERMINAL="alacritty"
export BROWSER="google-chrome-stable"

# Adds ~/.local/bin and subfolders to $PATH

export BREW=$(eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null)
# setup fzf
if exists fzf; then
  source <(fzf --zsh)
fi

