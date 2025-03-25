#!/usr/bin/env bash

# Simple testing framework for installers

set -e

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

# Import utility functions if they exist
UTILS_PATH="$PROJECT_PATH/src/utils.sh"
if [ -f "$UTILS_PATH" ]; then
  source "$UTILS_PATH"
fi

# Test cases directory
TEST_CASES_DIR="$PROJECT_PATH/test/cases"
echo "Test cases $TEST_CASES_DIR"

[ ! -d $TEST_CASES_DIR ] && echo "Test cases directory not found: $TEST_CASES_DIR" && exit 1

# Function to run a test
run_test() {
  local test_name="$1"
  local test_file="$2"

  echo -e "${YELLOW}Running test: ${test_name}${NC}"

  if bash "$test_file"; then
    echo -e "${GREEN}✓ Test passed: ${test_name}${NC}"
    return 0
  else
    echo -e "${RED}✗ Test failed: ${test_name}${NC}"
    return 1
  fi
}

# Function to run all tests in a directory
run_tests() {
  local test_dir="$1"
  local failed=0
  local passed=0

  for test_file in "$test_dir"/*.test.sh; do
    if [ -f "$test_file" ]; then
      total=$((total + 1))
      test_name=$(basename "$test_file" .test.sh)

      if run_test "$test_name" "$test_file"; then
        passed=$((passed + 1))
      else
        failed=$((failed + 1))
      fi
      echo ""
    fi
  done

  echo -e "${YELLOW}Test summary:${NC}"
  echo -e "Total: $total, ${GREEN}Passed: $passed${NC}, ${RED}Failed: $failed${NC}"

  return $failed
}

# Main function
main() {
  local test_dir="$TEST_CASES_DIR"

  # If specific test is provided
  if [ -n "$1" ]; then
    if [ -f "$TEST_CASES_DIR/$1.test.sh" ]; then
      run_test "$1" "$TEST_CASES_DIR/$1.test.sh"
      exit $?
    else
      echo -e "${RED}Test file not found: $1.test.sh${NC}"
      exit 1
    fi
  else
    # Run all tests
    run_tests "$test_dir"
    exit $?
  fi
}

# Execute main function
main "$@"
