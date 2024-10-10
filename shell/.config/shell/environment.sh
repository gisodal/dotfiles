#!/bin/bash

[ -n "$SHELL_CUSTOM_ENVIRONMENT" ] && return
SHELL_CUSTOM_ENVIRONMENT="set"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

PATH="$XDG_CONFIG_HOME/git/commands:$PATH"
PATH="$HOME/.local/bin:$PATH"
LOCALBINS=$(find ~/.local/bin -maxdepth 1 -type d 2>/dev/null | xargs printf "%s:")
PATH="$PATH:/opt/homebrew/bin:$BREW:$LOCALBINS:~/.local/share/coursier/bin:~/.config/git/commands"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
GIT_CONFIG_PATH="$HOME/.config/git"
PKG_CONFIG_PATH="$USR_LOCAL/lib/pkgconfig"
EDITOR="nvim"
VISUAL="nvim"
LC_ALL="en_US.UTF-8" # use UTF-8 character set
LANG="en_US.UTF-8"
LANGUAGE="en_US.UTF-8"
HISTTIMEFORMAT="[%Y-%m-%d %T] " # timestamp history commands
HISTCONTROL="ignoredups"        # dont record duplicate commands
HISTIGNORE="&:ls:cd:[bf]g:exit" # dont record simple commands like ls
MANPAGER="less -R --use-color -Dd+r -Du+b"
LESSHISTFILE="-"

# pnpm
PNPM_HOME="$HOME/.local/share/pnpm"
PATH="$PNPM_HOME:$PATH"
# pnpm end

NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if exists fdfind; then
  FZF_DEFAULT_COMMAND="fdfind --type file --hidden --no-ignore"
elif exists fd; then
  FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
elif exists rg; then
  FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
elif exists find; then
  FZF_DEFAULT_COMMAND="find ."
fi

if exists dircolors; then
  test -r $HOME/.lsrc && eval "$(dircolors --sh "$HOME/.lsrc")"
fi

if exists direnv; then
  eval "$(direnv hook bash)"
fi

# setup git user
GIT_USER_FILE="$HOME/.config/git/.gituser"
if [ ! -z "$PS1" -a ! -f "$GIT_USER_FILE" ]; then
  GITUSER=$USER@$HOSTNAME
  echo "Configure a git user and email:"
  read -p "    Using $GITUSER as username. Is that ok? (Y/n) " choice
  case "$choice" in
  y | Y | "") ;;
  *) read -p "    Enter username: " GITUSER ;;
  esac
  read -p "    Enter email: " GITMAIL

  printf "[user]\n    name = $GITUSER\n    email = $GITMAIL\n" >"$GIT_USER_FILE"
  echo -e "\n    Username '$GITUSER' and email '$GITMAIL' written to $GIT_USER_FILE"
fi

ulimit -c unlimited
