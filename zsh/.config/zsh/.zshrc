XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
ZSHRC="$ZDOTDIR/.zshrc"
PLUGINDIR="$ZDOTDIR/plugins"

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

# load git completions
autoload -Uz compinit && compinit

## options
unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

source $ZDOTDIR/aliases.zsh
if [[ $(uname) == "Darwin" ]]; then
    source $ZDOTDIR/aliases.osx.zsh
fi
source $XDG_CONFIG_HOME/lf/lfcd.sh

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


# detach function from terminal
function detach(){
    COMMAND=$1
    if [[ -n "$(command -v "$COMMAND")" ]]; then
        (nohup $@ </dev/null 1>/dev/null 2>&1 &)
    else
        echo "Command '$COMMAND' does not exist" 1>&2
        return 1
    fi
}

# go into a directory if there is only 1 to choose from.
function d() {
    NOTHIDDEN=$(find . -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*')
    NOTHIDDENCOUNT=$(find . -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*' -printf '.' | wc -c)

    if [ $NOTHIDDENCOUNT -eq 1 ]; then
        cd $NOTHIDDEN
    elif [ $NOTHIDDENCOUNT -eq 0 ]; then
        HIDDEN=$(find . -maxdepth 1 -mindepth 1 -type d -path '*/\.*')
        HIDDENCOUNT=$(find . -maxdepth 1 -mindepth 1 -type d -path '*/\.*' -printf '.' | wc -c)
        if [ $HIDDENCOUNT -eq 1 ]; then
            cd $HIDDEN
        else
            echo "No directories to go in to"
        fi
    else
        echo "More than one directories to choose from"
    fi
}

# either op a file with a default program or open a directory in nautilus.
function o() {
    if [ $# -eq 0 ]; then
        o "."
    elif [ $# -eq 1 -a -d "$@" ]; then
        detach nautilus "$@"
    elif [ $# -eq 1 -a -f "$@" ]; then
        detach open $@
    else
        echo "$# arguments are provided."  1>&2
        echo "Usage: o <filename|dirname>" 1>&2
        return 1
    fi
}


function rebuild_completions() {
    rm "$ZDOTDIR/.zcompdump"
    compinit
}

# add zoxide. This should be added after 'compinit'.
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
  
