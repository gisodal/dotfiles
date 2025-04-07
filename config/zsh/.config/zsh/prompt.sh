#!/bin/zsh

# -----------------------------------------------------------------------------
# prompt appearance
# -----------------------------------------------------------------------------

function prompt_hostname() {
  if [[ -z "$TMUX" ]]; then
    print -n "$(tput setaf 5)$(hostname)$(tput sgr0) "
  fi
}

function prompt_exit_code() {
  [ $1 -ne 0 ] && print -n "%K{160}%B $1 %b%k "
}

function prompt_location() {
  print -n "$(tput setaf 2)%(5~|.../%3~|%~)$(tput sgr0)"
}

# Set directory trimming
export PROMPT_DIRTRIM=2

# Set up prompts
setopt PROMPT_SUBST
export PROMPT='
$(prompt_exit_code $?)$(prompt_hostname)$(prompt_location) $(prompt_git_info)
> '
export PROMPT2='> '
