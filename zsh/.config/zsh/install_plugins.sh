#!/bin/bash

source "$HOME/.zshenv"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
ZSHRC="$ZDOTDIR/.zshrc"
PLUGINDIR="$ZDOTDIR/plugins"

mkdir -p "$PLUGINDIR"

cd $PLUGINDIR

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
git clone https://github.com/jeffreytse/zsh-vi-mode.git 
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 

echo "Add the following to your $ZDOTDIR/.zshrc"
echo

echo  "source  $PLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme"               
echo  "source  $PLUGINDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh"                  
echo  "source  $PLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 
echo  "source  $PLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"         
 
