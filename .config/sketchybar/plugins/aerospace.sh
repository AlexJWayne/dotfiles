#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
    sketchybar --set $NAME label.color=0xffffffff
else
    sketchybar --set $NAME background.drawing=off
    sketchybar --set $NAME label.color=0x66ffffff
fi
