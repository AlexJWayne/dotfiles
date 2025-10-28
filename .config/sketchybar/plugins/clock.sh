#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

time=$(date '+%a %b %e  %l:%M %p' | sed 's/PM/pm/g' | sed 's/AM/am/g')
sketchybar --set "$NAME" label="$time"
