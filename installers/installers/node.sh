#!/bin/bash
# Download and install nvm:

mkdir -p "${NVM_DIR:-$HOME/.nvm}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# in lieu of restarting the shell
\. "${NVM_DIR:-$HOME/.nvm}/nvm.sh"

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v     # Should print "v22.14.0".
nvm current # Should print "v22.14.0".

# Verify npm version:
npm -v # Should print "10.9.2".
