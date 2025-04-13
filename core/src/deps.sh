#!/bin/bash

function get-dep-parent() {
  echo "${1%%:*}"
}

function get-dep-child() {
  echo "${1#*:}"
}

function parse-deps-file() {
  log debug "Parse dependency file: $file (with parent '$parent', ref: '$3')"
  local parent=$1
  local file=$2
  local -n results="$3" # Name reference to the array

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

# Perform topological sort on dependencies
function get-install-order() {
  local -n deps_ref=$1 # Reference to dependency pairs array
  local -n result=$2   # Reference to result array
  local root_pkg=$3    # The starting package
  local -A visited=()
  local -A temp_mark=()
  local -a sorted=()

  # Helper to get all dependencies of a node
  function get-deps-of-node() {
    local node=$1
    local -a node_deps=()

    for ((j = 0; j < ${#deps_ref[@]}; j++)); do
      local parent=$(get-dep-child "${deps_ref[$j]}")
      local dep=$(get-dep-parent "${deps_ref[$j]}")

      if [[ "$parent" == "$node" ]]; then
        node_deps+=("$dep")
      fi
    done

    echo "${node_deps[@]}"
  }

  function visit() {
    local node=$1

    # Check for cyclic dependency
    if [[ ${temp_mark[$node]} ]]; then
      log error "Circular dependency detected involving package: $node"
      return 1
    fi

    # Skip already visited nodes
    if [[ ${visited[$node]} ]]; then
      return 0
    fi

    temp_mark[$node]=1

    # Visit all dependencies first
    for dep in $(get-deps-of-node "$node"); do
      visit "$dep" || return 1
    done

    # Mark as visited and add to sorted list
    unset temp_mark[$node]
    visited[$node]=1

    sorted+=("$node") # Add to the end instead of the beginning
  }

  # Start with the root package
  visit "$root_pkg"

  # Copy result to output array
  result=("${sorted[@]}")
}

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

function get-packages() {
  log debug "Determine dependencies for: $1"
  local -n results="$2" # Name reference to the array
  results=()

  local -a all_deps=()
  local -a queue=("$1")
  local -a processed=()
  while [ ${#queue[@]} -gt 0 ]; do
    local current=${queue[0]}
    queue=("${queue[@]:1}")

    log debug "Processing: $current : ${#queue[@]} ${queue[@]}"

    # Skip if already processed
    if [[ " ${processed[*]} " == *" $current "* ]]; then
      continue
    fi
    processed+=("$current")

    # is there a dependency file?
    if ! have-deps $current; then
      log debug "No dependency file found for: $current"
      continue
    fi

    # get file dependencies
    log debug "Process dependencies for: $current"
    local -a file_deps=()
    parse-deps-file $current $(get-deps-file $current) file_deps

    log debug "add  $current: ${file_deps[@]}"
    # get all parents for further dependency processing
    for dep in "${file_deps[@]}"; do
      queue+=("$(get-dep-parent $dep)")
    done

    # store found dependencies
    all_deps+=("${file_deps[@]}")
  done

  log debug "Nr of dependencies: ${#all_deps[@]}"
  for ((i = 0; i < ${#all_deps[@]}; i++)); do
    local parent=$(get-dep-parent "${all_deps[$i]}")
    local child=$(get-dep-child "${all_deps[$i]}")
    log debug "    Dependency: $parent → $child"
  done

  # get the installation order
  if ! get-install-order all_deps results "$1"; then
    return 1
  fi

  return 0
}
