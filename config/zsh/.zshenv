# .zshrc location
export ZDOTDIR="${XDG_CONFIG_HOME:=$HOME/.config}/zsh"

# Adds ~/.local/bin and subfolders to $PATH
export BREW=$(eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null)

