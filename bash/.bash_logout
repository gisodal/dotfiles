#!/bin/bash

# when leaving the console clear the screen to increase privacy

case "$TERM" in
    xterm*|rxvt*|screen*|linux*)
        echo -en "\033c"
        ;;
esac

