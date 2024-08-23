#!/usr/bin/env bash

# Set global variables
DIR="$HOME/.config/polybar"
XRANDR_CACHE=""
NETWORK_CACHE=""

# Function to launch Polybar on each connected monitor
launch_polybar() {
    pkill -x polybar
    for monitor in $(xrandr -q | awk '/ connected/ {print $1}'); do
        export MONITOR=$monitor
        export NETWORK_INTERFACE=$(nmcli -t -f active,device dev wifi | egrep '^yes' | cut -d':' -f2)
        polybar -q -c "$DIR/config.ini" main &
    done
}

# Monitor setup watcher to automatically refresh Polybar when monitors or network change
while true; do
    XRANDR_CURRENT=$(xrandr --listmonitors)
    NETWORK_CURRENT=$(nmcli -t -f active,device dev wifi | egrep '^yes' | cut -d':' -f2)
    if [ "$XRANDR_CURRENT" != "$XRANDR_CACHE" ] || [ "$NETWORK_CURRENT" != "$NETWORK_CACHE" ]; then
        launch_polybar
        XRANDR_CACHE=$XRANDR_CURRENT
        NETWORK_CACHE=$NETWORK_CURRENT
    fi
    sleep 5
done
