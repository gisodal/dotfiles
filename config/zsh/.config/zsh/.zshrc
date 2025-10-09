XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
ZSH_CONFIG_PATH=${ZSH_CONFIG_PATH:-$XDG_CONFIG_HOME/zsh}
SHELL_CONFIG_PATH=$XDG_CONFIG_HOME/shell
ZSHRC="$ZSH_CONFIG_PATH/.zshrc"
PLUGINDIR="$ZSH_CONFIG_PATH/plugins"


# History in cache directory:
HISTFILE=~/.cache/zsh/history
mkdir -p ~/.cache/zsh

# extend path
typeset -U path PATH # make path hold unique values

set -o allexport
source $SHELL_CONFIG_PATH/functions.sh

source $SHELL_CONFIG_PATH/env.sh

source $ZSH_CONFIG_PATH/env.sh

source $ZSH_CONFIG_PATH/functions.zsh

[ -f $HOME/.env ] && source $HOME/.env
set +o allexport

source $SHELL_CONFIG_PATH/alias.sh

source $ZSH_CONFIG_PATH/aliases.zsh
if [[ $(uname) == "Darwin" ]]; then
    source $ZSH_CONFIG_PATH/aliases.osx.zsh
fi

source $ZSH_CONFIG_PATH/options.zsh

source $SHELL_CONFIG_PATH/keymaps.sh

source $ZSH_CONFIG_PATH/prompt.sh

# load git completions
autoload -Uz compinit && compinit


function install_plugins() {
  source "$HOME/.zshenv"

  XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
  ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
  ZSHRC="$ZDOTDIR/.zshrc"
  PLUGINDIR="$ZDOTDIR/plugins"

  mkdir -p "$PLUGINDIR"

  cd $PLUGINDIR

  git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode.git
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git
}

if [ ! -d "$PLUGINDIR/zsh-vi-mode" ]; then
  install_plugins
fi

source $PLUGINDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $PLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' menu select

zmodload -i zsh/complist
bindkey -M menuselect '^i' accept-line
zstyle ':completion:*' menu select=1
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

