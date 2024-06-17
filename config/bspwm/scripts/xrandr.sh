#!/bin/bash

# Function to get display identifiers
get_display_ids() {
    primary_id=$(xrandr | grep " connected" | grep "primary" | awk '{print $1}')
    secondary_id=$(xrandr | grep " connected" | grep -v "primary" | awk '{print $1}')
}

# Get display identifiers
get_display_ids

# Check if secondary display exists before executing xrandr command
if [ -n "$secondary_id" ]; then
    xrandr --output "$primary_id" --auto --primary --output "$secondary_id" --auto --right-of "$primary_id"
    bspc monitor "$primary_id" -d 1 2 3 4 5
    bspc monitor "$secondary_id" -d 6 7 8 9 0
    polybar -r external &
fi
