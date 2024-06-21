#!/bin/bash

# Get the notification status using dunstctl
status=$(dunstctl is-paused | grep -q "false" && echo "enabled" || echo "disabled")

# Check if notifications are enabled or disabled
if [ "$status" = "enabled" ]; then
    icon=""
    text="On"
else
    icon=""
    text="Off"
fi

# Print the icon and text
echo "$icon $text"
