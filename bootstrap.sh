#!/bin/bash

USERNAME=dotkeeper
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
DOTFILES_HOME="${XDG_CONFIG_HOME}/dotfiles"
REPO_UPDATE=true

function usage() {
  local ME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
  cat <<EOF
Usage: $ME <command> [args]:

  Commands      Description
  --------      -----------
  install       Install dotfiles under new user '$USERNAME'
  login         Switch to the dotfiles user
  remove        Remove the dotfiles user

  Examples
  --------
  $ME install
  $ME install user1
  $ME login
  $ME remove
EOF
  exit 1
}

# Function to remove up (delete the user)
function remove() {
  echo "Deleting user $USERNAME"
  sudo pkill -u $USERNAME   # Kill any processes running as the user
  sudo userdel -r $USERNAME # Remove user and their home directory
  sudo rm -f /etc/sudoers.d/$USERNAME
  echo "User $USERNAME has been deleted"
}

function has-user() {
  id "$USERNAME" &>/dev/null
}

function have-command() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

function get-os() {
  case "$(uname -s)" in
  Linux)
    if ! have-command lsb_release; then
      echo "Cannot determine OS without lsb_release" >&$(tty)
      echo "unknown"
      return 1
    fi

    local os=$(lsb_release -si 2>/dev/null)
    echo "${os,,}"
    ;;
  Darwin)
    echo "macos"
    ;;
  *)
    echo "unknown"
    ;;
  esac
}

function create-user() {
  # create user
  sudo adduser --gecos "" --disabled-password $USERNAME

  # Grant sudo privileges by adding to sudo group
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USERNAME
  sudo chmod 440 /etc/sudoers.d/$USERNAME
}

function not-installed() {
  local not_installed=""
  local pkg
  for pkg in $@; do
    if ! have-command "$pkg"; then
      not_installed+=" $pkg"
    fi
  done

  echo "$not_installed"
}

function install-pkg() {
  local pkg=$1
  local os=$(get-os)

  if [[ "$os" == "ubuntu" ]]; then
    if $REPO_UPDATE; then
      echo "Updating apt repositories..."
      sudo apt update
      REPO_UPDATE=false
    fi

    case $pkg in
    nvim)
      sudo snap install --classic nvim
      ;;
    *)
      sudo apt install -y $pkg
      ;;
    esac

  elif [[ "$os" == "macos" ]]; then
    brew install $pkg
  else
    echo "No installer available for $pkg on OS: $(get-os)"
    return 1
  fi
}

function install-pkgs() {
  local pkgs=$@
  local pkg
  for pkg in $pkgs; do
    install-pkg $pkg
    if [ $? -ne 0 ]; then
      echo "Failed to install $pkg"
      return 1
    fi
  done
}

function install-config() {
  local pkgs="$(not-installed git stow tmux make g++ nvim)"
  if [[ -n "$pkgs" ]]; then
    echo "Installing missing packages: $pkgs"
    install-pkgs $pkgs || return 1
  fi

  sudo runuser -l $USERNAME -c "cat << 'EOF' | bash -e
rm -f .bash* .profile
mkdir -p .config
cd .config
[ ! -d dotfiles ] && git clone --depth=1 https://github.com/gisodal/dotfiles.git
cd dotfiles
./dot stow git
./dot stow tmux
./dot stow shell
./dot stow bash
./dot stow nvim
EOF"
}

function bootstrap() {
  # check if user exists
  if ! has-user; then
    create-user
  fi

  install-config
}

function login() {
  if [ -t 0 ]; then
    exec sudo -u $USERNAME -i
  else
    echo
    echo "Log into the user with:"
    echo
    echo "  sudo -u ${USERNAME} -i"
  fi
}

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script is only supported on Linux."
  exit 1
fi

case "$1" in
'remove')
  remove
  ;;
'login')
  login
  ;;
'install')
  bootstrap || exit 1
  login
  ;;
*)
  usage
  ;;
esac
