#!/usr/bin/env bash

# Set global variables
DIR="$HOME/.config/polybar"
XRANDR_CACHE=""

# Function to launch Polybar on each connected monitor
launch_polybar() {
    pkill -x polybar
    for monitor in $(xrandr -q | awk '/ connected/ {print $1}'); do
        MONITOR=$monitor polybar -q -c "$DIR/config.ini" main &
    done
}

# Monitor setup watcher to automatically refresh Polybar when monitors change
while true; do
    XRANDR_CURRENT=$(xrandr --listmonitors)
    if [ "$XRANDR_CURRENT" != "$XRANDR_CACHE" ]; then
        launch_polybar
        XRANDR_CACHE=$XRANDR_CURRENT
    fi
    sleep 5
done
