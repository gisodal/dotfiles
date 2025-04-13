#!/bin/bash

function get-core-paths() {
  local directory=$1
  local pattern=$2
  local os=$(get-os)
  local version=$(get-os-version)

  local paths=""
  paths+=$(find "$directory/$os/$version" -maxdepth 1 -type f -name "$pattern" 2>/dev/null || true)
  paths+=$'\n'
  paths+=$(find "$directory/$os" -maxdepth 1 -type f -name "$pattern" 2>/dev/null || true)
  paths+=$'\n'
  paths+=$(find "$directory" -maxdepth 1 -type f -name "$pattern" 2>/dev/null || true)

  echo "$paths"
}

function get-installer-paths() {
  get-core-paths "$INSTALLER_PATH" "*.sh"
}

function get-deps-paths() {
  get-core-paths "$DEPENDENCY_PATH" "*"
}

function get-check-paths() {
  get-core-paths "$CHECKS_PATH" "*.sh"
}

function get-installer() {
  get-installer-paths | command grep "/$1.sh$" | head -n 1
}

function get-check() {
  get-check-paths | command grep "/$1.sh$" | head -n 1
}

function get-deps-file() {
  get-deps-paths | command grep "/$1$" | head -n 1
}

function have-file() {
  local path=$1
  if [[ -n "$path" && -f "$path" ]]; then
    return 0
  else
    return 1
  fi
}

function have-installer() {
  have-file $(get-installer $1)
}

function have-check() {
  have-file $(get-check $1)
}

function have-deps() {
  have-file $(get-deps-file $1)
}

function get-installer-list() {
  local installers=$(get-installer-paths)
  local dep_files=$(get-dependency-paths)

  echo -e "$installers\n$dep_files" | sed -e "s/.*\///" -e "s/\.sh//" | sort | uniq
}
