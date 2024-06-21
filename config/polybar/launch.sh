#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Launch polybar for each monitor
for monitor in $(xrandr -q | awk '/ connected/ {print $1}'); do
    MONITOR=$monitor polybar -q -c $DIR/config.ini main &
done