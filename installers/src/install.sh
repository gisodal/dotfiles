#!/bin/bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
INSTALLERS="$SRC/installers.sh"

[ -f "$INSTALLERS" ] && source "$INSTALLERS" || (log error "Failed to load installers" && exit 1)

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
