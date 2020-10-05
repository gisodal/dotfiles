#!/bin/bash

# -----------------------------------------------------------------------------
# bash functions
# -----------------------------------------------------------------------------

# get script directory
function script_dir() {
    (cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
}

# detach function from terminal
function detach(){
    COMMAND=$1
    if [[ -n "$(command -v "$COMMAND")" ]]; then
        nohup $@ </dev/null 1>/dev/null 2>&1 &
    else
        echo "Command '$COMMAND' does not exist" 1>&2
    fi
}

# limit exec time of a function
function time-limit(){
    if [ $# -ge 2 ]; then
        perl -e 'alarm shift @ARGV; exec @ARGV' $1 ${@:2}
    else
        echo "Usage: time-limit <seconds> <command>" 1>&2
    fi
}

# generate ssh key
function keygen(){
    DIR="$HOME/.ssh"
    KEYS="$DIR/keys"
    KEY="$KEYS/id_rsa"
    OLDKEY="${KEY}_old"
    AUTH="$DIR/authorized_keys"
    mkdir -p "$KEYS"

    COMMENT="masterkey $(date '+%Y-%m-%d %H:%M:%S')"
    PUBKEY=$(cat "${KEY}.pub" 2>/dev/null)
    ssh-keygen -t rsa -b 4096 -N '' -f "$KEY" -C "$COMMENT"
    if [ ! -z "$PUBKEY" ]; then
        echo "Removing old key..."
        grep -v "$PUBKEY" "$AUTH" > "${AUTH}_new"
        cp "${AUTH}_new" "${AUTH}"
        rm "${AUTH}_new"
    fi
    cat "${KEY}.pub" >> "$AUTH"
}

# custom ls
function ls(){
    local cls="command ls --color=auto -v -h --group-directories-first"
    local options="-a -I .. -I . -I .git"
    [ $# -ne 0 ] && options=$@
    $cls $options
}

# perform ls after cd and put on stack, go back with ..
function cd(){
    local DIR=$@
    [ $# -eq 0 ] && DIR="$HOME"
    pushd "$DIR" 1>/dev/null 2>/dev/null && ls || echo "Directory '$DIR' does not exist" 1>&2 ;
}
# to pop: alias ..='popd &>/dev/null'

# confirmation dialog
# example:
# > confirm "do you want to continue?" && command
function confirm-dialog {
    PRMPT="$(if [ $# -gt 0 ]; then echo "$@"; else echo "Continue?"; fi;)"
    read -n 1 -p "$PRMPT [y/N]" response
    [[ ${response,,} =~ ^y$ ]] && true || false
}

# extract files
extract () {
    if [ -f "$@" ] ; then
        case "$@" in
            *.tar.bz2)  tar xvjf "$@" ;;
            *.tar.gz)   tar xvzf "$@" ;;
            *.tar.xz)   tar Jxvf "$@" ;;
            *.bz2)      bunzip2 "$@" ;;
            *.rar)      unrar x "$@" ;;
            *.gz)       gunzip "$@" ;;
            *.tar)      tar xvf "$@" ;;
            *.tbz2)     tar xvjf "$@" ;;
            *.tgz)      tar xvzf "$@" ;;
            *.zip)      unzip "$@" ;;
            *.Z)        uncompress "$@" ;;
            *.7z)       7z x "$@" ;;
            *)      echo "don't know how to extract '$@'..." ;;
        esac
    else
        echo "'$@' is not a valid file!"
    fi
}

# force tilde expansion off
_expand(){
    return 0;
}

# create dir and go into it
mkcd() {
    mkdir -p "$@"
    cd "$@"
}

