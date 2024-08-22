#!/bin/bash

# Define workspace names
workspace_names=("I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X")

# Get the primary monitor (assuming eDP-1 is primary, adjust as needed)
primary_monitor=$(xrandr --query | awk '/ connected primary/ {print $1}')

# Get the number of monitors
num_monitors=$(xrandr --query | awk '/ connected/ {print $1}' | wc -l)

# Calculate the number of workspaces per monitor
workspaces_per_monitor=$((${#workspace_names[@]} / num_monitors))

# Counter to track workspace assignment
workspace_counter=0

# Iterate through all connected monitors
for monitor in $(xrandr --query | awk '/ connected/ {print $1}'); do
    # Determine the workspaces to assign to this monitor
    monitor_workspaces=("${workspace_names[@]:workspace_counter:workspaces_per_monitor}")

    # Assign the workspaces to the current monitor
    bspc monitor "$monitor" -d "${monitor_workspaces[@]}"

    # If the monitor is not the primary, position it to the right of the primary
    if [ "$monitor" != "$primary_monitor" ]; then
        xrandr --output "$monitor" --auto --right-of "$primary_monitor"
        primary_monitor="$monitor" # Set the current monitor as the new primary for the next iteration
    fi

    # Increment workspace_counter for the next monitor
    workspace_counter=$((workspace_counter + workspaces_per_monitor))
done
