#!/usr/bin/env bash

# Simple testing framework for installers

set -e

DOCKER_DOTFILES_PATH="/home/testuser/dotfiles"
DOCKER_INSTALLER_PATH="$DOCKER_DOTFILES_PATH/installers/installers"
DOCKER_CONTAINER_NAME="dotkeeper-test"

DOTFILES_PATH=$(git rev-parse --show-toplevel)
TEST_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
CONTAINER_PATH="$TEST_PATH/containers"

TOTAL=0
PASSED=0
FAILED=0

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

IMAGE_SYSTEM=ubuntu-24.04

function attach-docker-container() {
  # After tests finish, if container still exists, connect to it
  container_id=$(sudo docker ps -q --filter "ancestor=$DOCKER_CONTAINER_NAME")
  if [ -n "$container_id" ]; then
    echo "Connecting to test container for debugging..."
    sudo docker exec -it $container_id /bin/bash
  else
    echo "Failed to get container id" && exit 1
  fi
}

function get-docker-file() {
  local dockerfile="$CONTAINER_PATH/Dockerfile.$IMAGE_SYSTEM"
  if [ -f "$dockerfile" ]; then
    echo "$dockerfile"
  else
    echo "Could not find Dockerfile for system '$IMAGE_SYSTEM'" 1>&2
    exit 1
  fi
}

function get-docker-image-name() {
  echo "dotkeeper-dotfiles-test-$IMAGE_SYSTEM"
}

function build_docker_image() {
  local docker_image=$(get-docker-image-name)
  local docker_file=$(get-docker-file)

  sudo docker build -t $docker_image -f "$docker_file" "$DOTFILES_PATH"
  if ! docker image inspect "$docker_image" &>/dev/null; then
    echo -e "${CYAN}➤ Building docker image...${NC}"
    sudo docker build -t "$docker_image" -f "$docker_file" "$DOTFILES_PATH"
  else
    echo -e "${CYAN}➤ Using existing docker image: ${docker_image}${NC}"
  fi

}

function run_docker_test() {
  local docker_image=$(get-docker-image-name)
  build_docker_image

  local run_cmd=$1
  if [[ -n $CONTAINER_DEBUG ]]; then
    log warn "Running in debug mode"
    run_cmd="if ! $run_cmd; then echo -e '\nExecution failed. Starting bash shell.\n'; bash; false; fi"
  fi

  echo "container: $DOCKER_CONTAINER_NAME"
  echo "image: $docker_image"
  echo "=== Docker test $1 ==="
  sudo docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:rw -it --rm \
    -v "$DOTFILES_PATH:$DOCKER_DOTFILES_PATH" \
    -e DOTKEEPER_LOGLEVEL=$LOGLEVEL \
    -e DOTKEEPER_DRYRUN=$DRYRUN \
    --name $DOCKER_CONTAINER_NAME \
    $docker_image \
    "$run_cmd"

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
  local run_args="$@"
  local cmd="dot $run_args"

  log warn "Run: ./$cmd"
  if run_docker_test "$DOCKER_DOTFILES_PATH/$cmd"; then
    echo -e "${GREEN}✓ Test passed: ${cmd}${NC}"
    PASSED=$((PASSED + 1))
    return 0
  else
    echo -e "${RED}✗ Test failed: ${cmd}${NC}"
    FAILED=$((FAILED + 1))
    return 1
  fi
}

function run_test_installers() {
  local installers=$($DOTFILES_PATH/dot list-install)

  log info "Running tests for installers:"
  for pkg in $installers; do
    log info "  - $pkg"
  done

  local ignore="media-post plex"
  for installer in $installers; do
    if [ $installer == "media-post" ]; then
      continue
    fi
    run_in_container install $installer
  done
}

function run_test_stow() {
  local stowable=$($DOTFILES_PATH/dot list-stow)

  log info "Running tests for stow:"
  for pkg in $stowable; do
    log info "  - $pkg"
  done

  for pkg in $stowable; do
    run_in_container stow $pkg
  done
}

# Function to run all tests in a directory
run_tests() {

  run_test_installers

  run_test_stow

  echo -e "${YELLOW}Test summary:${NC}"
  echo -e "Total: $TOTAL, ${GREEN}Passed: $PASSED${NC}, ${RED}Failed: $FAILED${NC}"

  return $FAILED
}

# select a test system
SYSTEMS=$(find $CONTAINER_PATH -name 'Dockerfile*' | sed 's:.*Dockerfile.\(.*\):\1:')
if [[ -n $SYSTEM_SELECT ]]; then
  set +e
  ask "Select system to test" $SYSTEMS
  position=$?
  set -e

  IMAGE_SYSTEM=$(echo "$SYSTEMS" | sed -n "${position}p")
fi

# run tests
if [ $# -eq 0 ]; then
  if [[ -n $SYSTEM_SELECT ]]; then
    echo -e "${YELLOW}Running tests for system: $IMAGE_SYSTEM${NC}"
    run_tests
  else
    for system in "$SYSTEMS"; do
      IMAGE_SYSTEM=$system
      echo -e "${YELLOW}Running tests for system: $IMAGE_SYSTEM${NC}"
      run_tests
    done
  fi
else
  echo -e "${YELLOW}Running tests for system: $IMAGE_SYSTEM${NC}"
  run_in_container $@
fi
