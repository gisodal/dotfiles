#!/bin/bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
INSTALLERS="$SRC/installers.sh"

[ -f "$INSTALLERS" ] && source "$INSTALLERS" || (log error "Failed to load installers" && exit 1)

function filter-installable() {
  local -n results="$1" # Name reference to the array
  local -a filtered=()

  for pkg in "${results[@]}"; do
    # Keep packages that either have an installer or don't have dependency files
    if have-installer "$pkg" || ! have-deps "$pkg"; then
      filtered+=("$pkg")
    else
      log debug "Filtered out $pkg (is not installable)"
    fi
  done

  # Replace results with filtered array
  results=("${filtered[@]}")
}

function is-installed() {
  # check if the dependency is already installed
  if have-check $pkg; then
    if (
      set -e
      source "$(get-check $pkg)"
    ); then
      log info "Package '$pkg' already installed"
      return 0
    fi

  # we don't have a custom check, so default to checking for the binary
  elif have-command $pkg; then
    log info "Package '$pkg' already installed: $(which $pkg)"
    return 0
  fi

  return 1
}

function install() {
  log debug "Install $1"

  # determine what to install
  declare -a packages
  get-packages "$1" packages
  filter-installable packages

  log info "Install packages:"
  for pkg in "${packages[@]}"; do
    log info "  - $pkg"
  done

  for pkg in "${packages[@]}"; do
    log info "Install package: $pkg"

    if is-installed $pkg; then
      continue
    fi

    # check if we have an installer
    if ! have-installer $pkg; then
      log error "There is no installer for '$pkg'"
      return 1
    fi

    # run the installer
    (
      set -e
      source "$(get-installer $pkg)"
    )

    # check if the dependency was installed
    if [ $? -eq 0 ]; then
      log info "Package '$pkg' installed"
    else
      log error "Package '$pkg' failed to install"
      return 1
    fi
  done
}
