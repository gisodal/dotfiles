#!/bin/bash

#depends on: imagemagick, i3lock, scrot

ICON=$HOME/.config/wallpaper/lock-icon-512.png
IMAGE=/tmp/screen.png
scrot $IMAGE
convert $IMAGE -scale 10% -scale 1000%  -fill black -colorize 40% $IMAGE
convert $IMAGE $ICON -gravity center -composite -matte $IMAGE
i3lock --ignore-empty-password --nofork --image $IMAGE

#  if [[ -f $ICON ]] 
#  then
#      # placement x/y
#      PX=0
#      PY=0
#      # lockscreen image info
#      R=$(file $ICON | grep -o '[0-9]* x [0-9]*')
#      RX=$(echo $R | cut -d' ' -f 1)
#      RY=$(echo $R | cut -d' ' -f 3)
#   
#      SR=$(xrandr --query | grep ' connected' | cut -f3 -d' ')
#      for RES in $SR
#      do
#          # monitor position/offset
#          SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
#          SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
#          SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
#          SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
#          PX=$(($SROX + $SRX/2 - $RX/2))
#          PY=$(($SROY + $SRY/2 - $RY/2))
#   
#          convert $IMAGE $ICON -geometry +$PX+$PY -composite -matte  $IMAGE
#          echo "done"
#      done
#  fi 
#  # dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
#  #i3lock  -I 10 -d -e -n -i $IMAGE
#  i3lock --ignore-empty-password --nofork --image $IMAGE

rm $IMAGE
