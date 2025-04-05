#!/bin/bash

# install getnf (easy nerdfont install)
# https://github.com/getnf/getnf
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# install jetbrains
$HOME/.local/bin/getnf -i JetBrainsMono
