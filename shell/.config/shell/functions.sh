#!/bin/bash

# -----------------------------------------------------------------------------
# bash functions
# -----------------------------------------------------------------------------

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
