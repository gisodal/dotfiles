#!/bin/bash

# -----------------------------------------------------------------------------
# prompt appearance
# -----------------------------------------------------------------------------

function prompt_hostname() {
  if [[ -z "$TMUX" ]]; then
    echo -ne "$(tput bold)$(tput setaf 5)$(hostname)$(tput sgr0) "
  fi
}

function prompt_exit_code() {
  [ $1 -ne 0 ] && printf "$(tput bold)$(tput setab 160) ${1#0} $(tput sgr0) "
}

function prompt_location() {
  local path_full=$(dirs)
  path_full=${path_full%% *} # Take only the first directory from dirs output

  # Count the number of slashes to determine directory depth
  local depth=$(echo "$path_full" | tr -cd '/' | wc -c)

  if [ "$depth" -gt 3 ]; then
    # More than 3 directories deep, add ... prefix
    echo -e "$(tput setaf 2)...$path_full$(tput sgr0)"
  else
    # Otherwise show the full path without ...
    echo -e "$(tput setaf 2)$path_full$(tput sgr0)"
  fi
}

export PS1="\n\$(prompt_exit_code \$?)\$(prompt_hostname)\$(prompt_location) \$(prompt_git_info)\n> "
export PS2='> '
