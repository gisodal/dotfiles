#!/bin/bash

# -----------------------------------------------------------------------------
# bash functions
# -----------------------------------------------------------------------------

function f {
  CAT=$(exists bat && echo "bat" || exists batcat && echo "batcat" || cat)

  PREVIEWER=$((exists bat || exists batcat) && echo "$CAT --style=numbers --color=always --line-range {2}:500 {1}" || echo "cat {1}")

  RESULT=$(rg --vimgrep --hidden --color ansi "$@" | fzf --ansi --preview 'echo {} | awk -F: "{print \$1, \$2}" | xargs -I {1} {2} '"$PREVIEWER")

  FILE=$(echo "$RESULT" | cut -d : -f 1)
  LINE=$(echo "$RESULT" | cut -d : -f 2)
  COLUMN=$(echo "$RESULT" | cut -d : -f 3)

  if [[ -f $FILE ]]; then
    read -p "Do you want to open $FILE? [Y/n] " response
    if [[ -z $response || ${response,,} == "y" ]]; then
      nvim +$LINE +"normal ${COLUMN}|" $FILE
    fi
  fi
}

function exists() {
  command -v $1 &>/dev/null
  return $?
}

# get script directory
function script_dir() {
  (cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
}

# detach function from terminal
function detach() {
  COMMAND=$1
  if [[ -n "$(command -v "$COMMAND")" ]]; then
    (nohup $@ </dev/null 1>/dev/null 2>&1 &)
  else
    echo "Command '$COMMAND' does not exist" 1>&2
    return 1
  fi
}

# either op a file with a default program or open a directory in nautilus.
function o() {
  if [ $# -eq 0 ]; then
    o "."
  elif [ $# -eq 1 -a -d "$@" ]; then
    detach nautilus "$@"
  elif [ $# -eq 1 -a -f "$@" ]; then
    detach open $@
  else
    echo "$# arguments are provided." 1>&2
    echo "Usage: o <filename|dirname>" 1>&2
    return 1
  fi
}

# limit exec time of a function
function time-limit() {
  if [ $# -ge 2 ]; then
    perl -e 'alarm shift @ARGV; exec @ARGV' $1 ${@:2}
  else
    echo "Usage: time-limit <seconds> <command>" 1>&2
  fi
}

function ls() {
  if exists eza; then
    eza --icons --git --ignore-glob='**/.git' --time-style=long-iso --group-directories-first -a $@
  elif [ $(uname) == "Darwin" ]; then
    ls --color=auto -v -h -a -I .. -I . -I .git $@
  else
    ls --color=auto -v -h -a -I .. -I . -I .git --group-directories-first $@
  fi
}

# perform ls after cd and put on stack, go back with ..
function cd() {
  local DIR=$@
  [ $# -eq 0 ] && DIR="$HOME"
  pushd "$DIR" 1>/dev/null 2>/dev/null && ls || echo "Directory '$DIR' does not exist" 1>&2
}
# to pop: alias ..='popd &>/dev/null'

# confirmation dialog
# example:
# > confirm "do you want to continue?" && command
function confirm-dialog {
  PRMPT="$(if [ $# -gt 0 ]; then echo "$@"; else echo "Continue?"; fi)"
  read -n 1 -p "$PRMPT [y/N]" response
  [[ ${response,,} =~ ^y$ ]] && true || false
}

# extract files
extract() {
  if [ -f "$@" ]; then
    case "$@" in
    *.tar.bz2) tar xvjf "$@" ;;
    *.tar.gz) tar xvzf "$@" ;;
    *.tar.xz) tar Jxvf "$@" ;;
    *.bz2) bunzip2 "$@" ;;
    *.rar) unrar x "$@" ;;
    *.gz) gunzip "$@" ;;
    *.tar) tar xvf "$@" ;;
    *.tbz2) tar xvjf "$@" ;;
    *.tgz) tar xvzf "$@" ;;
    *.zip) unzip "$@" ;;
    *.Z) uncompress "$@" ;;
    *.7z) 7z x "$@" ;;
    *) echo "don't know how to extract '$@'..." ;;
    esac
  else
    echo "'$@' is not a valid file!"
  fi
}

# force tilde expansion off
_expand() {
  return 0
}

# create dir and go into it
mkcd() {
  mkdir -p "$@"
  cd "$@"
}

function activateprefix {
  PREFIX="$1"
  export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig/"
  export LD_LIBRARY_PATH="${PREFIX}/lib/"
  export LD_RUN_PATH="${PREFIX}/lib/"
  export LIBRARY_PATH="${PREFIX}/lib/"
  export CPLUS_INCLUDE_PATH="${PREFIX}/include/"
  export C_INCLUDE_PATH="${PREFIX}/include/"
}

function colors() {
  for ((i = 0; i < 256; i++)); do
    echo -n '  '
    tput setab $i
    tput setaf $((((i > 231 && i < 244) || ((i < 17) && (i % 8 < 2)) || (\
    i > 16 && i < 232) && ((i - 16) % 6 < (i < 100 ? 3 : 2)) && ((i - 16) % 36 < 15)) ? 7 : 16))
    printf "   %03d   " $i
    tput op
    ((((i < 16 || i > 231) && ((i + 1) % 8 == 0)) || ((i > 16 && i < 232) && ((i - 15) % 6 == 0)))) &&
      printf "\n" ''
  done
}
