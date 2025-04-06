#!/bin/bash

function add-to-path() {
  if [[ -n $1 ]]; then
    local newpath=":$PATH:"
    newpath=${newpath//:$1:/:}
    # Remove leading/trailing colons and export
    newpath=${newpath#:}
    newpath=${newpath%:}
    # Add to beginning of PATH
    export PATH="$1:$newpath"
  fi
}

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
XDG_CACHE_HOME="$HOME/.cache"

LOCALBINS=$(find ~/.local/bin -maxdepth 1 -type d 2>/dev/null | xargs printf "%s:")
GIT_CONFIG_PATH="$XDG_CONFIG_HOME/git"

add-to-path "$GIT_CONFIG_PATH/commands"
add-to-path "$LOCALBINS"
add-to-path "$HOME/.local/bin"
add-to-path "/opt/homebrew/bin"

EDITOR="nvim"
VISUAL="nvim"
LC_ALL="en_US.UTF-8" # use UTF-8 character set
LANG="en_US.UTF-8"
LANGUAGE="en_US.UTF-8"

HISTTIMEFORMAT="[%Y-%m-%d %T] " # timestamp history commands
HISTCONTROL="erasedups"         # dont record duplicate commands
HISTIGNORE="&:ls:cd:exit"       # dont record simple commands like ls
HISTSIZE=10000
HISTFILESIZE=10000

MANPAGER="less -R --use-color -Dd+r -Du+b"

# ================= application specific ==================
# pnpm
PNPM_HOME="$HOME/.local/share/pnpm"
PATH="$PNPM_HOME:$PATH"
# pnpm end

[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

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
  test -r $XDG_CONFIG_HOME/shell/.lsrc && eval "$(dircolors --sh "$XDG_CONFIG_HOME/shell/.lsrc")"
fi

if exists direnv; then
  eval "$(direnv hook bash)"
fi

# git config
GIT_USER_FILE="$GIT_CONFIG_PATH/.gituser"
if [ -d "$GIT_CONFIG_PATH" -a ! -f "$GIT_USER_FILE" ]; then
  GITUSER=$USER@$(hostname)
  GITMAIL="none"

  if [ -t 0 ]; then
    echo "Configure a git user and email:"
    echo -n "    Using $GITUSER as username. Is that ok? (Y/n) "
    read choice
    case "$choice" in
    y | Y | "") ;;
    *)
      echo -n "    Enter username: "
      read GITUSER
      echo -n "    Enter email: "
      read GITMAIL
      ;;
    esac
  fi

  echo -e "[user]\n    name = $GITUSER\n    email = $GITMAIL\n" >"$GIT_USER_FILE"
  echo -e "\n    Username '$GITUSER' and email '$GITMAIL' written to $GIT_USER_FILE"
fi
