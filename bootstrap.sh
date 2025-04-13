#!/bin/bash

USERNAME=dotkeeper
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
DOTFILES_HOME="${XDG_CONFIG_HOME}/dotfiles"

function usage() {
  local ME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
  cat <<EOF
Usage: $ME <command> [args]:

  Commands              Description
  --------              -----------
  install [username]    Install the dotfiles under user (default: $USERNAME)
  login [username]      Switch to the user (default: $USERNAME)
  clean [username]      Cleanup the user (default: $USERNAME)

  Examples
  --------
  $ME install
  $ME install user1
  $ME login
  $ME clean
EOF
  exit 1
}

# Function to clean up (delete the user)
function cleanup() {
  echo "Deleting user $USERNAME"
  sudo pkill -u $USERNAME   # Kill any processes running as the user
  sudo userdel -r $USERNAME # Remove user and their home directory
  sudo rm -f /etc/sudoers.d/$USERNAME
  echo "User $USERNAME has been deleted"
}

function has_user() {
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
    if have-command lsb_release; then
      local os=$(lsb_release -si 2>/dev/null)
      echo "${os,,}"
    else
      echo "unknown"
    fi
    ;;
  Darwin)
    echo "macos"
    ;;
  *)
    echo "unknown"
    ;;
  esac
}

function create_user() {
  # create user
  sudo adduser --gecos "" --disabled-password $USERNAME

  # Grant sudo privileges by adding to sudo group
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USERNAME
  sudo chmod /etc/sudoers.d/$USERNAME
}

function install_config() {

  if [[ "$(get-os)" == "ubuntu" ]]; then
    sudo apt install -y git stow tmux
    sudo snap install nvim --classic
  else
    echo "You will need to install git, stow, tmux and nvim manually before proceeding. "
    return 1
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
  if ! has_user; then
    create_user
  fi

  install_config
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

USERNAME=${2:-$USERNAME}
case "$1" in
'clean')
  cleanup
  ;;
'login')
  login
  ;;
'install')
  bootstrap
  login
  ;;
*)
  usage
  ;;
esac
