#!/bin/bash

# Exit on error
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
DOCKER_DIR="$REPO_ROOT/installers/test/docker"

if [ ! -d "$DOCKER_DIR" ]; then
  echo "docker directory not found: $DOCKER_DIR"
  exit 1
fi

echo "=== Building Docker test image ==="
sudo docker build -t dotfiles-test -f "$DOCKER_DIR/Dockerfile" "$REPO_ROOT"

echo
echo "=== Running tests in Docker container ==="
echo "Mount: $REPO_ROOT:/home/testuser/dotfiles"
echo

sudo docker run -it --rm \
  -v "$REPO_ROOT:/home/testuser/dotfiles" \
  -e CONTAINER_DEBUG=$CONTAINER_DEBUG \
  --name dotfiles-test-container \
  dotfiles-test \
  /home/testuser/dotfiles/installers/test/docker/bootstrap.sh run.test.sh

# Check exit code from docker run
if [ $? -eq 0 ]; then
  echo
  echo "=== Docker tests completed successfully ==="
else
  echo
  echo "=== Docker tests failed ==="
  exit 1
fi
