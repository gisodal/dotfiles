#!/bin/zsh

# -----------------------------------------------------------------------------
# async git info
# -----------------------------------------------------------------------------

typeset -g _prompt_git_info=""
typeset -g _prompt_git_fd=

function _prompt_git_callback() {
  local fd=$1
  {
    IFS= read -r -u "$fd" _prompt_git_info || true
  } always {
    zle -F "$fd"
    exec {fd}<&-
    _prompt_git_fd=
  }
  zle && zle reset-prompt
}

function _prompt_precmd() {
  # close previous async worker if still running
  if [[ -n "$_prompt_git_fd" ]]; then
    zle -F "$_prompt_git_fd" 2>/dev/null
    exec {_prompt_git_fd}<&- 2>/dev/null
  fi

  # start background worker — result arrives via _prompt_git_callback
  exec {_prompt_git_fd}< <(prompt_git_info)
  zle -F "$_prompt_git_fd" _prompt_git_callback
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd

# -----------------------------------------------------------------------------
# prompt string (no subshells — pure zsh prompt escapes)
# -----------------------------------------------------------------------------

export PROMPT_DIRTRIM=2
setopt PROMPT_SUBST

# %(?.. ) = only show on non-zero exit
# %m = hostname, %~ = path with ~ substitution
# %(5~|.../%3~|%~) = truncate path if >5 deep
_prompt_hostname=""
[[ -z "$TMUX" ]] && _prompt_hostname=$'\033[35m%m\033[0m '

export PROMPT=$'\n%(?..%K{160}%B %? %b%k )'"${_prompt_hostname}"$'\033[32m%(5~|.../%3~|%~)\033[0m ${_prompt_git_info}\n> '
export PROMPT2='> '
