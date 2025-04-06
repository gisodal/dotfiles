#!/bin/bash

function get-installer() {
  echo "$INSTALLER_PATH/$1.sh"
}

function get-check() {
  echo "$CHECKS_PATH/$1.sh"
}

function get-installer-list() {
  local INSTALLERS=$(find $INSTALLER_PATH -type f -name "*.sh" | sed -e "s/.*\///" -e "s/\.sh//")
  local DEP_FILES=$(find $DEPENDENCY_PATH -type f -name "*" | sed -e "s/.*\///" -e "s/\.sh//")
  echo -e "$INSTALLERS\n$DEP_FILES" | sort | uniq
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
