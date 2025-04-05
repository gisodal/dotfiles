XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
ZSH_CONFIG_PATH=${ZSH_CONFIG_PATH:-$XDG_CONFIG_HOME/zsh}
SHELL_CONFIG_PATH=$XDG_CONFIG_HOME/shell
ZSHRC="$ZSH_CONFIG_PATH/.zshrc"
PLUGINDIR="$ZSH_CONFIG_PATH/plugins"

# start TMUX before the p10k is initialized: https://github.com/romkatv/powerlevel10k/issues/1203
case $- in *i*)
      if  [ -z "$SSH_TTY" ]         && \
        [ -z "$SSH_CONNECTION" ]    && \
        [ -z "$SSH_CLIENT" ]        && \
        [ -n "$DISPLAY" ]           && \
        [ -z "$TMUX"  ]; then
        exec tmux -2 -u
      fi
esac

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
mkdir -p ~/.cache/zsh

# extend path
typeset -U path PATH # make path hold unique values

set -o allexport
source $SHELL_CONFIG_PATH/functions.sh

source $SHELL_CONFIG_PATH/environment.sh

source $ZSH_CONFIG_PATH/environment.sh

source $ZSH_CONFIG_PATH/functions.zsh
set +o allexport

source $SHELL_CONFIG_PATH/alias.sh

source $ZSH_CONFIG_PATH/aliases.zsh
if [[ $(uname) == "Darwin" ]]; then
    source $ZSH_CONFIG_PATH/aliases.osx.zsh
fi

source $ZSH_CONFIG_PATH/options.zsh

source $SHELL_CONFIG_PATH/keymaps.sh

# load git completions
autoload -Uz compinit && compinit


source $PLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme
source $PLUGINDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $PLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' menu select

zmodload -i zsh/complist
bindkey -M menuselect '^i' accept-line
zstyle ':completion:*' menu select=1
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f $ZSH_CONFIG_PATH/.p10k.zsh ]] || source $ZSH_CONFIG_PATH/.p10k.zsh
  
