#!/bin/bash

echo "=== Testing installer functionality ==="
echo

# Change to installers directory
cd /home/testuser/dotfiles/installers

sudo apt-get update

echo "1. Running './run -v install nvim'..."
./run -v install nvim
INSTALL_EXIT=$?
echo "Install exit code: $INSTALL_EXIT"
if [ $INSTALL_EXIT -eq 0 ]; then
  echo "✓ Installation completed successfully"
else
  echo "✗ Installation failed with exit code $INSTALL_EXIT"
  exit 1
fi

echo
echo "2. Verifying dependency installations..."
nvm --version
for cmd in npm node rg fzf nvim; do
  if command -v $cmd >/dev/null 2>&1; then
    echo "✓ $cmd is installed"
  else
    echo "✗ $cmd is NOT installed"
    exit 1
  fi
done

echo
echo "3. Running './run -v stow nvim'..."
./run -v stow nvim
STOW_EXIT=$?
echo "Stow exit code: $STOW_EXIT"
if [ $STOW_EXIT -eq 0 ]; then
  echo "✓ Stow completed successfully"
else
  echo "✗ Stow failed with exit code $STOW_EXIT"
  exit 1
fi

echo
echo "4. Verifying nvim config installation..."
if [ -d ~/.config/nvim ]; then
  echo "✓ ~/.config/nvim directory exists"
  ls -la ~/.config/nvim
else
  echo "✗ ~/.config/nvim directory does NOT exist"
  exit 1
fi

echo
echo "=== All tests passed! ==="
