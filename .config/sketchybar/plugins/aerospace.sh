#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate sin 4 --set $NAME label.color=0xffffffff background.color=0x66000000
else
    sketchybar --animate sin 4 --set $NAME label.color=0x66ffffff background.color=0x00000000
fi
