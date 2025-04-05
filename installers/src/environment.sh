#!/bin/bash

PROJECT_PATH="$(git rev-parse --show-toplevel)/installers"
INSTALLER_PATH="$PROJECT_PATH/installers"
CHECKS_PATH="$PROJECT_PATH/checks"
DEPENDENCY_PATH="$PROJECT_PATH/deps"
STOW_SOURCE=$(git rev-parse --show-toplevel)/config
