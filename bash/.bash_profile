#!/bin/bash

# this file is called for login shells. .bashrc is called for non-login shells.

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
