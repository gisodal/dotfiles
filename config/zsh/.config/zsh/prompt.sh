#!/bin/zsh

# -----------------------------------------------------------------------------
# prompt appearance
# -----------------------------------------------------------------------------

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
$(prompt_exit_code $?)$(prompt_location) $(prompt_git_info)
> '
export PROMPT2='> '
