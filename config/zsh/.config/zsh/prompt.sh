#!/bin/zsh

# -----------------------------------------------------------------------------
# prompt appearance
# -----------------------------------------------------------------------------

function prompt_hostname() {
  [[ -z "$TMUX" ]] && print -n '\033[35m%m\033[0m '
}

function prompt_exit_code() {
  [[ $1 -ne 0 ]] && print -n "%K{160}%B $1 %b%k "
}

function prompt_location() {
  print -n '\033[32m%(5~|.../%3~|%~)\033[0m'
}

# -----------------------------------------------------------------------------
# async git info
# -----------------------------------------------------------------------------

typeset -g _prompt_last_exit=0
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
  _prompt_last_exit=$?

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
# prompt string
# -----------------------------------------------------------------------------

export PROMPT_DIRTRIM=2
setopt PROMPT_SUBST
export PROMPT='
$(prompt_exit_code $_prompt_last_exit)$(prompt_hostname)$(prompt_location) ${_prompt_git_info}
> '
export PROMPT2='> '
