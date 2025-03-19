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
source "$DIR/deps.sh"

function get-installer() {
  echo "$INSTALLERS/$1.sh"
}

function get-check() {
  echo "$CHECK/$1.sh"
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
