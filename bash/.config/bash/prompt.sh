#!/bin/bash

# -----------------------------------------------------------------------------
# 256 colors
# -----------------------------------------------------------------------------

function print-colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done | column
}
export -f print-colors

# -----------------------------------------------------------------------------
# prompt appearance
# -----------------------------------------------------------------------------

function prompt_exit_code() {
  [ $1 -ne 0 ] && printf "$(tput bold)$(tput setaf 160)${1#0} $(tput sgr0)"
}

function prompt_location() {
  echo -n "\[$(tput setaf 2)\]\w\[$(tput sgr0)\]"
}

function prompt_git_info() {
  if git rev-parse --show-toplevel 2>/dev/null 1>&2; then
    local REPO=$(basename $(git rev-parse --show-toplevel))
    local CHANGES=$(git diff-index --quiet HEAD -- && echo "" || echo "*")
    local BRANCH=$(git symbolic-ref HEAD 2>/dev/null)
    BRANCH=${BRANCH##refs/heads/}
    BRANCH=${BRANCH:-detached}

    echo -e "$(tput setaf 4)$REPO $(tput setaf 214)$BRANCH${CHANGES}$(tput sgr0)"
  fi
}

PROMPT_DIRTRIM=2
export PS1="\n\$(prompt_exit_code \$?)$(prompt_location) \$(prompt_git_info)\n> "
export PS2='> '