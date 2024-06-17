#!/bin/bash

# Get the Capture status using amixer and extract the dB value
status=$(amixer sget Capture | awk -F"[][]" '/\[on\]/ {print "enabled"; exit} /\[off\]/ {print "disabled"; exit}')

# Check if Capture is enabled or disabled
if [ "$status" = "enabled" ]; then
    icon=""  # Icon for enabled state
    text="Capture: On"
else
    icon=""  # Icon for disabled state
    text="Capture: Off"
fi

# Print the icon and text
echo "$icon $text"
