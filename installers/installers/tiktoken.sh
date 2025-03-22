#!/bin/bash

# tiktoken requires the rust compiler
sudo apt install -y cargo

# install tiktoken
sudo luarocks install --lua-version 5.1 tiktoken_core
