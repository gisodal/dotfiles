#!/bin/bash

function get-stow-list() {
  for dir in "$STOW_SOURCE"/*/; do
    basename="${dir%/}"
    basename="${basename##*/}"
    [ "$basename" != "installers" ] && echo "$basename"
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
  *)
    :
    ;;
  esac

  log info "Stow $PACKAGE"

  # modify ownership if necessary
  if [[ -n $SUDO ]]; then
    sudo chown -R root:root "$PACKAGE_DIR"
  fi

  local STOW_DRYRUN
  $DRYRUN && STOW_DRYRUN="--no -v" # stow the pacakge
  CMD="$SUDO stow $OPT -vt $TARGET -d $STOW_SOURCE $PACKAGE"
  $DRYRYN && log warn "Dry run: $CMD" || echo $CMD

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
