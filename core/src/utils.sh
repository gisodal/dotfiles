#!/bin/bash

function get-os-version() {
  if have-command lsb_release; then
    lsb_release -sr 2>/dev/null
  fi
}

function get-os() {
  case "$(uname -s)" in
  Linux)
    if have-command lsb_release; then
      local os=$(lsb_release -si 2>/dev/null)
      echo "${os,,}"
    else
      echo "unknown"
    fi
    ;;
  Darwin)
    echo "macos"
    ;;
  *)
    echo "unknown"
    ;;
  esac
}

function load_environment() {
  set -o allexport
  source "$STOW_SOURCE/shell/.config/shell/functions.sh"
  source "$STOW_SOURCE/shell/.config/shell/environment.sh"
  set +o allexport
}

function has_service() {
  if systemctl list-unit-files --type=service | grep -q "$1.service"; then
    echo "Service is already installed"
    return 0
  else
    return 1
  fi
}

function have-command() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

function sort_array_unique() {
  local -n arr="$1" # Name reference to the array
  local sorted_arr

  if [ ${#arr[@]} -eq 0 ]; then
    return
  fi

  # Using readarray to capture sorted output back into array
  readarray -t sorted_arr < <(printf '%s\n' "${arr[@]}" | awk '{ print length($0) " " $0 }' | sort -n | cut -d' ' -f2- | uniq)
  # Replace original array with sorted array
  arr=("${sorted_arr[@]}")
}
