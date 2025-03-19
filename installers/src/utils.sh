#!/bin/bash

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
