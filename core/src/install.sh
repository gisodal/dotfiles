#!/bin/bash

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
  load_environment

  # check if the dependency is already installed
  if have-check $1; then
    if (
      set -e
      source "$(get-check $1)"
    ); then
      log info "Package '$1' is installed (checked with $(get-check $1))"
      return 0
    fi

  # we don't have a custom check, so default to checking for the binary
  elif have-command $1; then
    log info "Package '$1' is installed: $(which $1)"
    return 0
  fi

  return 1
}

function install-fallback() {
  local pkg="$1"
  log warn "Fallback to default installer for '$pkg'"

  # Check if snap is available
  if have-command snap; then
    log info "Trying to install '$pkg' with snap..."
    if $DRYRUN; then
      log warn "Dry run: sudo snap install $pkg"
    else
      sudo snap install "$pkg" && return 0
    fi
  fi

  # If snap fails or isn't available, try apt
  if have-command apt; then
    log info "Trying to install '$pkg' with apt..."
    if $DRYRUN; then
      log warn "Dry run: sudo apt-get install -y $pkg"
    else
      sudo apt-get update && sudo apt-get install -y "$pkg" && return 0
    fi
  fi

  $DRYRUN && return 0

  log error "Failed to install '$pkg'. No suitable package manager found."
  return 1
}

function install() {
  log debug "Install $1"

  # go to build directory to install stuff
  BUILD="$HOME/.local/opt"
  mkdir -p "$BUILD"
  command cd "$BUILD"

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
      log warn "There is no installer for '$pkg'"
      install-fallback $pkg || return 1
      continue
    fi

    # run the installer
    if $DRYRUN; then
      log warn "Dry run: $(get-installer $pkg)"
    else
      (
        # disable alias expansion
        \unalias -a 2>/dev/null || true

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
    fi
  done
  return 0
}
