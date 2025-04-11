#!/bin/bash

function get-stow-list() {
  for dir in "$STOW_SOURCE"/*/; do
    basename="${dir%/}"
    basename="${basename##*/}"
    echo "$basename"
  done
}

function stow-remove-conflicts() {
  local pkg=$1

  # Get conflicts from stow dry run
  stow --simulate --verbose -t "$TARGET" "$pkg" 2>&1 | grep -o "existing target is not owned by stow: .*" | sed 's/existing target is not owned by stow: //' | while read -r target; do
    local full_path="$TARGET/$target"
    if [ -L "$full_path" ]; then
      echo "Removing existing symlink: $full_path"
      rm "$full_path"
    elif [ -e "$full_path" ]; then
      echo "Warning: $full_path exists and is not a symlink. Manual action required."
    fi
  done
}

function stow-core() {
  local TARGET=$HOME
  local PACKAGE=$1
  local PACKAGE_DIR="$STOW_SOURCE/$PACKAGE"

  # determine run arguments
  case $PACKAGE in
  "local")
    OPT="--no-folding"
    ;;
  "media")
    OPT="--no-folding"
    SUDO=sudo
    TARGET="/"
    ;;
  "bash")
    rm "$HOME/.bash_logout"
    rm "$HOME/.bashrc"
    rm "$HOME/.profile"
    ;;
  *)
    :
    ;;
  esac

  log info "Stow $PACKAGE"

  # modify ownership if necessary
  if [[ -n $SUDO ]]; then
    sudo chown -R root:root "$PACKAGE_DIR"
  fi

  stow-remove-conflicts $PACKAGE

  local STOW_DRYRUN
  $DRYRUN && STOW_DRYRUN="--no -v" # stow the pacakge
  CMD="$SUDO stow $OPT -vt $TARGET -d $STOW_SOURCE $PACKAGE"
  $DRYRUN && log warn "Dry run: $CMD" || echo $CMD

  $CMD $STOW_DRYRUN

  return $?
}

function stow-post() {
  local PACKAGE=$1

  # determine run arguments
  case $PACKAGE in
  "media")
    install media-post
    ;;
  *)
    :
    ;;
  esac
}

function stow-install() {
  local PACKAGE=${1%/}
  if [ ! -d "$STOW_SOURCE/$PACKAGE" ]; then
    echo "Package $PACKAGE not found" 1>&2
    return 1
  fi

  if ! stow-core $PACKAGE; then
    return 1
  fi

  if ! stow-post $PACKAGE; then
    return 1
  fi

  return 0
}
