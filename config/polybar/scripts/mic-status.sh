#!/bin/bash

# Get the Capture status using amixer and extract the dB value
status=$(amixer sget Capture | awk -F"[][]" '/\[on\]/ {print "enabled"; exit} /\[off\]/ {print "disabled"; exit}')

# Check if Capture is enabled or disabled
if [ "$status" = "enabled" ]; then
    icon=""
    text="On"
else
    icon=""
    text="Off"
fi

# Print the icon and text
echo "$icon $text"
