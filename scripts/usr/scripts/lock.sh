#!/bin/bash

ICON=$HOME/.config/wallpaper/lock-icon-512.png
IMAGE=/tmp/screen.png
scrot $IMAGE
convert $IMAGE -scale 10% -scale 1000%  -fill black -colorize 40% $IMAGE
convert $IMAGE $ICON -gravity center -composite -matte $IMAGE

i3lock -i $IMAGE
rm $IMAGE
