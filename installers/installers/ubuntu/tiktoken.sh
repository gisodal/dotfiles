#!/bin/bash

sudo apt update

# tiktoken requires the rust compiler
sudo apt-get install -y cargo

# Install luarocks (Lua package manager)
sudo apt-get install -y luarocks

# Ensure we have the development libraries for Lua
sudo apt-get install -y liblua5.1-dev

# install tiktoken
sudo luarocks install --lua-version 5.1 tiktoken_core

# Verify installation
luarocks --lua-version 5.1 list | grep tiktoken_core
