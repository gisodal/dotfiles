#!/bin/bash

# -----------------------------------------------------------------------------
# bash functions
# -----------------------------------------------------------------------------

# detach function from terminal
function detach(){
    COMMAND=$1
    if [[ -n "$(command -v "$COMMAND")" ]]; then
        (nohup env -i DISPLAY=$DISPLAY $@ </dev/null >/dev/null 2>&1 &)
    else
        echo "Command '$COMMAND' does not exist" 1>&2
    fi
}

#if [ $(command -v complete) ]; then
#    complete -c -o filenames detach
#fi

# compile automake projects with debug symbols
function debug-conf-make(){
    if [ ! -f configure ]; then
        echo "No configure file found." 1>&2
        return 1
    fi

    INSTALLDIR="debug"
    if [ -d $INSTALLDIR ]; then
        echo "Directory '$INSTALLDIR' already exist. Aborting." 1>&2
        return 1
    fi

    mkdir $INSTALLDIR
    cd $INSTALLDIR
    ../configure --prefix=$(pwd) CFLAGS="-DDEBUG -g -O0" CPPFLAGS=-DDEBUG CXXFLAGS="-g -O0" \
        && make && make install
}

# limit exec time
function time-limit(){
    if [ $# -ge 2 ]; then
        perl -e 'alarm shift @ARGV; exec @ARGV' $1 ${@:2}
    else
        echo "Usage: time-limit <seconds> <command>" 1>&2
    fi
}

# wake-up pcs
function wake-silveru(){
    if [[ $HOSTNAME == lilo* ]]; then
        MACS=(
            $(cat $HOME/archive/personal/silveru/mac)
            $(cat $HOME/archive/personal/silveru/spoofmac)
        )
        IPS=(
            $(cat $HOME/archive/personal/silveru/ip)
            $(cat $HOME/archive/personal/silveru/spoofip)
        )

        IP=${IP[0]}
        BASEIP="${IP%.*}."
        echo base: $BASEIP
                   exit
        for ((i=0; i < ${#MAC[@]}; i++)); do
            echo
            echo "Using MAC:'${MAC[$i]}' at IP:'${IP[$i]}'"
            if [ "${MAC[$i]}" != "" -a "${IP[$i]}" != "" ]; then
                wol -i ${IP[$i]} ${MAC[$i]}
            else
                echo "MAC and/or IP not found!" 1>&2
            fi
        done
    else
        echo "Not on lilo!" 1>&2
    fi
}

function tgdb(){
    bash --noprofile --norc -c "gdb -tui $@"
}

function cgdb(){
    local CGDB=$(which cgdb)
    if [ -n "$CGDB" ]; then
        bash --noprofile --norc -c "$CGDB $@"
    else
        echo "cgdb not found" 1>&2
    fi
}

function colormake(){
    exec 9>&2
    exec 7> >(
        while IFS='' read -r line || [ -n "$line" ]; do
            if [[ $line == *:[\ ]error:* ]] || [[ $line == *:[\ ]undefined* ]] || [[ $line == *:[\ ]fatal\ error:* ]] || [[ $line == *:[\ ]multiple[\ ]definition* ]]; then
                echo -e "\033[1m\033[31m${line}${RS}"
            elif [[ $line == *:[\ ]warning:* ]]; then
                echo -e "$(EXT_COLOR 202)${line}${RS}"
            else
                echo -e "\033[1m$(EXT_COLOR 8)${line}${RS}"
            fi
        done
    )
    exec 2>&7
    function ctrl_c() { exec 2>&9; }
    trap ctrl_c INT
    make $@
    trap -- INT
    exec 2>&9
}

function cleanenv(){
    if [ $# -ne 0 ]; then

        env -i \
            HOME=\"$HOME\" \
            PATH=\"$PATH\" \
            LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH\"
            USER=\"$USER\" \
            bash --norc --noprofile -c $@
    else
        echo "Usage: cleanenv <program> [arglist]" 1>&2
    fi
}

# create encrypted archives
function encrypt-archive(){
    ARCH="$1"
    if [ $# -eq 1 ]; then
        export XZ_OPT="-9" && tar -cvJ $ARCH | gpg -c -o $ARCH.tar.xz.gpg
    else
        echo "Usage: encrypt-archive <file/folder name>"
    fi
}

function decrypt-archive(){
    ARCH="$1"
    if [ $# -eq 1 ]; then
        gpg -d $ARCH | tar -xvJ
    else
        echo "Usage: decrypt-archive <filename>"
    fi
}

# local and remote ip addresses
function localip(){
    hostname -I | awk '{print $1}'
}

function remoteip(){
    curl watismijnip.nl 2>/dev/null | grep -io "ipadress:\ [^\ ^<]*" | awk -F' ' '{print $2}'
}

# list all options used by bash
function options(){
    (shopt && set -o && bind -v | sed 's:^set::') | column -t | nl
}

# md5 hash of string
function md5str(){
    echo -n "$@" | md5sum | awk '{print $1}'
}

function vob2mkv (){
    if [ $# -ge 2 ]; then
        INPUT=${@:1:$(($#-1))}
        OUTPUT=${!#}
        TMP=${RANDOM}.VOB
        echo "Joining $INPUT"
        cat $INPUT > $TMP
        echo "Creating mkv file.."
        #sudo apt-get install libavcodec-extra-53
        ffmpeg -i $TMP -vcodec libx264 -acodec copy -sn $OUTPUT
        echo "Remove temporary VOB file.."
        rm $TMP
        echo "DONE"
    else
        echo "Usage: ./vob2mkv <input files> <output file>" 1>&2
    fi

}

# show dir contents with sizes
function lss(){
    du -sh * .??* 2>/dev/null | sort -h
    echo -e "\nTotal: $(du -sh | awk '{print $1}')\n"
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

# print date
function now(){
    date '+%Y-%m-%d %H:%M:%S'
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
# > confirm "do you want to continue? [y/N]" && command
function confirm {
    PRMPT="$(if [ $# -gt 0 ]; then echo "$@"; else echo "Continue? [y/N]"; fi;)"
    read -r -p "$PRMPT " response
    response=${response,,}    # tolower
    if [[ $response =~ ^(yes|y)$ ]]; then
        true
    else
        false
    fi
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

# show colors used by ls
function lscolors(){
    eval $(echo "no:global default;fi:normal file;di:directory;ln:symbolic link;pi:named pipe;so:socket;do:door;bd:block device;cd:character device;or:orphan symlink;mi:missing file;su:set uid;sg:set gid;tw:sticky other writable;ow:other writable;st:sticky;ex:executable;"|sed -e 's/:/="/g; s/\;/"\n/g')
    {
        IFS=:
        for i in $LS_COLORS; do
            echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
        done
    }
}

git-show(){
    if [ $# -ne 1 ]; then
        echo "Usage: git-show <branch>:<file>" 1>&2
        return 1
    fi

    git show "$1" | vim - -c "set filetype=${1##*.} nobuflisted buftype=nofile bufhidden=wipe noswapfile";
}

