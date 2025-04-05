#!/bin/bash

sudo apt update
sudo apt-get install openssh-server -y
sudo systemctl enable ssh
