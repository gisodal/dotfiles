#!/usr/bin/env bash

# Simple testing framework for installers

set -e

DOCKER_IMAGE="dotfiles-test"
DOCKER_DOTFILES_PATH="/home/testuser/dotfiles"
DOCKER_PROJECT_PATH="$DOCKER_DOTFILES_PATH/installers"
DOCKER_INSTALLER_PATH="$DOCKER_PROJECT_PATH/installers"

DOTFILES_PATH=$(git rev-parse --show-toplevel)
PROJECT_PATH="$DOTFILES_PATH/installers"
TEST_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

TOTAL=0
PASSED=0
FAILED=0

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

function build_docker_image() {
  sudo docker build -t $DOCKER_IMAGE -f "$TEST_PATH/Dockerfile" "$DOTFILES_PATH"
  if ! docker image inspect "${DOCKER_IMAGE}" &>/dev/null; then
    echo -e "${CYAN}➤ Building docker image...${NC}"
    sudo docker build -t $DOCKER_IMAGE -f "$TEST_PATH/Dockerfile" "$DOTFILES_PATH"
  else
    echo -e "${CYAN}➤ Using existing docker image: ${DOCKER_IMAGE}${NC}"
  fi

}

function run_docker_test() {
  build_docker_image

  echo "=== Docker test $1 ==="
  sudo docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:rw -it --rm \
    -v "$DOTFILES_PATH:$DOCKER_DOTFILES_PATH" \
    -e CONTAINER_DEBUG=$CONTAINER_DEBUG \
    --name dotfiles-test-container \
    $DOCKER_IMAGE \
    $1

  # Check exit code from docker run
  if [ $? -eq 0 ]; then
    echo
    echo "=== Docker test $1 completed successfully ==="
    return 0
  else
    echo
    echo "=== Docker test $1 failed ==="
    return 1
  fi
}

# Function to run a test
function run_in_container() {
  local RUN_ARGS="$@"
  local CMD="run $RUN_ARGS"

  log warn "Run: ./$CMD"
  if run_docker_test "$DOCKER_PROJECT_PATH/$CMD"; then
    echo -e "${GREEN}✓ Test passed: ${CMD}${NC}"
    PASSED=$((PASSED + 1))
    return 0
  else
    echo -e "${RED}✗ Test failed: ${CMD}${NC}"
    FAILED=$((FAILED + 1))
    return 1
  fi
}

# Function to run a test
function run_test_installer() {
  local test_name="$1"

  TOTAL=$((TOTAL + 1))
  echo -e "${YELLOW}Running test: ${test_name}${NC}"

  echo "$DOCKER_PROJECT_PATH/run install $1 "
  if run_docker_test "$DOCKER_PROJECT_PATH/run install $1"; then
    echo -e "${GREEN}✓ Test passed: ${test_name}${NC}"
    PASSED=$((PASSED + 1))
    return 0
  else
    echo -e "${RED}✗ Test failed: ${test_name}${NC}"
    FAILED=$((FAILED + 1))
    return 1
  fi
}

function run_test_installers() {
  local INSTALLERS=$($PROJECT_PATH/run ls)

  log info "Running tests for installers:"
  for pkg in $INSTALLERS; do
    log info "  - $pkg"
  done

  for installer in $INSTALLERS; do
    if [ $installer == "media-post" ]; then
      continue
    fi
    run_test_installer $installer
  done
}

# Function to run all tests in a directory
run_tests() {

  run_test_installers

  echo -e "${YELLOW}Test summary:${NC}"
  echo -e "Total: $TOTAL, ${GREEN}Passed: $PASSED${NC}, ${RED}Failed: $FAILED${NC}"

  return $FAILED
}

if [ $# -eq 0 ]; then
  run_tests
else
  run_in_container $@
fi
