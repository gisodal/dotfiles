#!/bin/bash -x

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

BUILD="$ROOT/build"
DEPS="$ROOT/deps"
CHECKS="$ROOT/checks"
INSTALLERS="$ROOT/installers"

# go to build directory to install stuff
mkdir -p "$BUILD"
command cd "$BUILD"

# grab the utils
source "$DIR/utils.sh"

function get-installer() {
  echo "$INSTALLERS/$1.sh"
}

function get-check() {
  echo "$CHECK/$1.sh"
}

function get-deps() {
  echo "$DEPS/$1"
}

function get-installer-list() {
  local INSTALLERS=$(find $INSTALLERS -type f -name "*.sh" | sed -e "s/.*\///" -e "s/\.sh//")
  local DEPS=$(find $DEPS -type f -name "*" | sed -e "s/.*\///")

  echo -e "$INSTALLERS\n$DEPS" | sort | uniq
}

function have-installer() {
  if [ -f $(get-installer $1) ]; then
    return 0
  else
    return 1
  fi
}

function have-check() {
  if [ -f $(get-check $1) ]; then
    return 0
  else
    return 1
  fi
}

function have-deps() {
  if [ -f $(get-deps $1) ]; then
    return 0
  else
    return 1
  fi
}

function parse_dependency_file() {
  local parent=$1
  local file=$2
  local -n result="$3" # Name reference to the array

  # Clear the result array
  result=()

  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Split line into array of dependencies
    read -ra deps <<<"$line"

    # Skip if line is empty after parsing
    [ ${#deps[@]} -eq 0 ] && continue

    # create dependency result
    for ((i = 0; i < ${#deps[@]}; i++)); do
      if [ $i -eq $((${#deps[@]} - 1)) ]; then
        results+=("${deps[$i]}:$parent")
      else
        results+=("${deps[$i]}:${deps[$i + 1]}")
      fi
    done
  done <"$file"

  # sort the results. remove duplicates
  sort_array_unique results
}

function get-dependencies() {
  local -n results="$2" # Name reference to the array
  results=()

  log debug "Checking dependencies for $1 at $(get-deps $1)"
  if [ ! -f $(get-deps $1) ]; then
    return 0
  fi

  parse_dependency_file $1 $(get-deps $1) results

  for ((i = 0; i < ${#results[@]}; i++)); do
    local dep=$(pair_left "${results[$i]}")
    local parent=$(pair_right "${results[$i]}")
    log debug "Dependency: $dep → $parent"
  done

  # sort the dependencies
  local -a sorted_deps
  topo_sort_deps results sorted_deps "$1"

  # copy back to result. exclude the last element, i.e., $1
  if [[ ${#sorted_deps[@]} -gt 0 ]]; then
    results=("${sorted_deps[@]:0:${#sorted_deps[@]}-1}")
  else
    results=()
  fi

  return 0
}

function install() {
  log debug "Install $1"

  declare -a dependencies
  get-dependencies "$1" dependencies

  log debug "Dependencies in installation order:"
  for pkg in "${dependencies[@]}"; do
    log debug "  - $pkg"
  done

  return 0

  # check if we have an installer for the dependency
  if ! have-installer $1; then
    log error "There is no installer for '$1'"
    return 1
  fi

  # check if the dependency is already installed
  if have-check $1; then
    if eval "$(get-check $1)"; then
      log info "Dependency '$1' already installed"
      return 0
    fi

  # we don't have a custom check, so default to checking for the binary
  elif command -v $1 1>/dev/null; then
    log info "Dependency '$1' already installed: $(which $1)"
    return 0
  fi

  # run the installer
  (
    set -e
    eval "$(get-installer $1)"
  )

  # check if the dependency was installed
  if [ $? -eq 0 ]; then
    log info "Dependency '$1' installed"
  else
    log error "Dependency '$1' failed to install"
    return 1
  fi
}
