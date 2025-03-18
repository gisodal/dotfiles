#!/bin/bash

function pair_left() {
  echo "${1%%:*}"
}

function pair_right() {
  echo "${1#*:}"
}

function sort_array_unique() {
  local -n arr="$1" # Name reference to the array
  local sorted_arr

  if [ ${#arr[@]} -eq 0 ]; then
    return
  fi

  # Using readarray to capture sorted output back into array
  readarray -t sorted_arr < <(printf '%s\n' "${arr[@]}" | awk '{ print length($0) " " $0 }' | sort -n | cut -d' ' -f2- | uniq)
  # Replace original array with sorted array
  arr=("${sorted_arr[@]}")
}

# Perform topological sort on dependencies
function topo_sort_deps() {
  local -n deps_ref=$1 # Reference to dependency pairs array
  local -n result=$2   # Reference to result array
  local root_pkg=$3    # The starting package
  local -A visited=()
  local -A temp_mark=()
  local -a sorted=()

  # Helper to get all dependencies of a node
  function get_deps_of_node() {
    local node=$1
    local -a node_deps=()

    for ((j = 0; j < ${#deps_ref[@]}; j++)); do
      local parent=$(pair_right "${deps_ref[$j]}")
      local dep=$(pair_left "${deps_ref[$j]}")

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
    for dep in $(get_deps_of_node "$node"); do
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
