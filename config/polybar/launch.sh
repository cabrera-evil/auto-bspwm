#!/usr/bin/env bash

# Set global variables
DIR="$HOME/.config/polybar"
XRANDR_CACHE=""
NETWORK_CACHE=""

# Function to get the active network interface (Wi-Fi or Ethernet)
get_active_network_interface() {
    # Check for connected interfaces (Wi-Fi or Ethernet)
    nmcli -t -f DEVICE,STATE d | awk -F: '$2 == "connected" {print $1}'
}

# Function to launch Polybar on each connected monitor
launch_polybar() {
    # Kill existing Polybar instances
    killall -q polybar

    # Loop through all connected monitors
    for monitor in $(xrandr -q | awk '/ connected/ {print $1}'); do
        export MONITOR=$monitor

        # Get the active network interface
        export NETWORK_INTERFACE=$(get_active_network_interface)

        # Launch Polybar for the current monitor
        polybar -q -c "$DIR/config.ini" main &
    done
}

# Monitor and network setup watcher to automatically refresh Polybar
while true; do
    # Check the current monitor and network setup
    XRANDR_CURRENT=$(xrandr --listmonitors)
    NETWORK_CURRENT=$(get_active_network_interface)

    # Refresh Polybar if monitors or network interface changes
    if [ "$XRANDR_CURRENT" != "$XRANDR_CACHE" ] || [ "$NETWORK_CURRENT" != "$NETWORK_CACHE" ]; then
        launch_polybar
        XRANDR_CACHE=$XRANDR_CURRENT
        NETWORK_CACHE=$NETWORK_CURRENT
    fi

    # Sleep for a few seconds before re-checking
    sleep 5
done
