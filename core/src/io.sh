#!/bin/bash

# ask - a simple prompt function
#
# usage:
#  ask "Run Debug of Release?" "Debug" "Release"
#  case $? in
#  1)
#    BUILD="Debug"
#    ;;
#  2)
#    BUILD="Release"
#    ;;
#  esac

function ask() {
  local PROMPT=$1
  local OPTIONS=("${@:2}")
  local VALUE

  # redo the last choice
  if $RERUN; then
    VALUE=${CHOICES[0]}
    CHOICES=("${CHOICES[@]:1}")
  fi

  # ask the user
  while [[ -z $VALUE ]]; do
    echo "$PROMPT:"
    local counter=1
    for OPTION in "${OPTIONS[@]}"; do
      echo "  $counter) $OPTION"
      ((counter++))
    done

    read -p "[1-${#OPTIONS[@]}]? " -n 1 VALUE
    echo -ne "\n\n"

    if [[ $VALUE -gt ${#OPTIONS[@]} ]]; then
      echo -e "Select a proper value..\n" 1>&2
      VALUE=
    fi
  done

  # record the choice
  CHOICES+=($VALUE)
  return $VALUE
}

function log() {
  local level=$1
  shift

  local -A log_priority=(
    ["verbose"]=1
    ["debug"]=2
    ["info"]=3
    ["warn"]=4
    ["error"]=5
  )

  LOGLEVEL=${LOGLEVEL:-info}
  if [[ ${log_priority[$level]:-0} -lt ${log_priority[$LOGLEVEL]:-2} ]]; then
    return
  fi

  case $level in
  debug)
    echo -e "\e[34m[$level] $@\e[0m"
    ;;
  info)
    echo -e "\e[32m$@\e[0m"
    ;;
  warn)
    echo -e "\e[33m[$level] $@\e[0m"
    ;;
  error)
    echo -e "\e[31m[$level] $@\e[0m"
    ;;
  *)
    echo -e "\e[31m[$level] $@\e[0m"
    ;;
  esac
}
