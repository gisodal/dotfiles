#!/bin/zsh

# -----------------------------------------------------------------------------
# async git info
# -----------------------------------------------------------------------------

typeset -g _prompt_git_info=""
typeset -g _prompt_git_fd=

# zsh-only variant using %F{}%f so prompt width calc stays correct under
# reset-prompt (raw \033 escapes would be counted as visible chars).
function _prompt_git_info_zsh() {
  local toplevel state branch desc
  toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || return
  state=$(git state) || return
  branch=${state%%[~:*]*}
  desc=$(git config branch."$branch".description 2>/dev/null)
  printf '%%F{blue}%s %%F{214}%s %%F{242}%s%%f' \
    "${toplevel##*/}" "$state" "$desc"
}

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
    # NB: no `2>/dev/null` on the exec — `exec` with no command applies
    # redirections to the shell permanently, which would silence stderr
    # for the rest of the session.
    exec {_prompt_git_fd}<&-
    _prompt_git_fd=
  fi

  # start background worker — result arrives via _prompt_git_callback
  exec {_prompt_git_fd}< <(_prompt_git_info_zsh)
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
[[ -z "$TMUX" ]] && _prompt_hostname='%F{magenta}%m%f '

export PROMPT=$'\n%(?..%K{160}%B %? %b%k )'"${_prompt_hostname}"$'%F{green}%(5~|.../%3~|%~)%f ${_prompt_git_info}\n> '
export PROMPT2='> '
