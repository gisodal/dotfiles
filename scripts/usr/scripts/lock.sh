#!/bin/bash

#scrot /tmp/screen.png
##convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
#convert /tmp/screen.png -scale 10% -scale 1000% -fill black -colorize 25% /tmp/screen.png 
#[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
#i3lock -i /tmp/screen.png
#rm /tmp/screen.png


ICON=$HOME/.config/wallpaper/lock-icon-512.png
IMAGE=/tmp/screen.png
scrot $IMAGE
convert $IMAGE -scale 10% -scale 1000%  -fill black -colorize 40% $IMAGE
convert $IMAGE $ICON -gravity center -composite -matte $IMAGE

i3lock -i $IMAGE
rm $IMAGE
