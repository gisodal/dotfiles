# .zshrc location
export ZDOTDIR="${XDG_CONFIG_HOME:=$HOME/.config}/zsh"

# Homebrew environment (cached — regenerated when brew binary is updated)
if [[ -x /opt/homebrew/bin/brew ]]; then
  _brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew_shellenv"
  if [[ ! -f "$_brew_cache" || /opt/homebrew/bin/brew -nt "$_brew_cache" ]]; then
    /opt/homebrew/bin/brew shellenv > "$_brew_cache" 2>/dev/null
  fi
  eval "$(< "$_brew_cache")"
  unset _brew_cache
fi

