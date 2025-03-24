#!/bin/bash

#sudo apt-get install -y curl unzip libfuse2

\unalias -a 2>/dev/null || true
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Detect architecture
ARCH=$(uname -m)
case $(uname -s) in
'Darwin')
  case "$ARCH" in
  x86_64)
    NVIM_ARCH="macos-x86_64"
    ;;
  aarch64 | arm64)
    NVIM_ARCH="macos-arm64"
    ;;
  *)
    echo "unsupported architecture: $arch"
    exit 1
    ;;
  esac
  ;;
'Linux')
  case "$ARCH" in
  x86_64)
    NVIM_ARCH="linux-x86_64"
    echo "Detected x86_64 architecture"
    ;;
  aarch64 | arm64)
    NVIM_ARCH="linux-arm64"
    echo "Detected ARM64 architecture"
    ;;
  *)
    echo "unsupported architecture: $arch"
    exit 1
    ;;
  esac
  ;;
*)
  echo "Unsupported OS: $(uname -s)"
  exit 1
  ;;
esac

NVIM_URLS=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -e "browser_download_url.*tar.gz" | grep -v 'sha.*sum' | grep -o 'http[^"]*')

if [ -z "$NVIM_URLS" ]; then
  echo "Failed to fetch Neovim release URLs"
  exit 1
else
  echo -e "NVIM URLs to select from:\n$NVIM_URLS"
fi

# Get the latest release URL for the detected architecture
NVIM_URL=$(echo "$NVIM_URLS" | grep "${NVIM_ARCH}")

[[ -z "$NVIM_URL" ]] && echo "Failed to fetch Neovim release URL for $NVIM_ARCH" && exit 1

echo "Downloading Neovim from: $NVIM_URL"
ARCHIVE="nvim-${NVIM_ARCH}.tar.gz"
curl -L -o "$ARCHIVE" "$NVIM_URL"

## Extract the archive
tar xzf nvim-${NVIM_ARCH}.tar.gz

echo "visit $TEMP_DIR"
## Install Neovim to /usr/local

mkdir -p $HOME/.local
TARGET="$HOME/.local"
cp -r nvim-${NVIM_ARCH}/* "$TARGET"

# Clean up
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo "Neovim installed successfully to $TARGET"
$TARGET/bin/nvim --version
