#!/bin/bash

wget -nc https://invisible-island.net/archives/lynx/tarballs/lynx2.9.2.tar.gz
tar -xzf lynx2.9.2.tar.gz
command cd lynx2.9.2
sudo ./configure
sudo make
sudo make install
