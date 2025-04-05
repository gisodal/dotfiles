#!/bin/bash

sudo apt update
sudo apt-get install -y snapd

# Ensure the core snap is installed
sudo snap install core
