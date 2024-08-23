#!/usr/bin/env bash

# Define workspace names
workspace_names=("I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X")

# Function to get the primary monitor (assuming eDP-1 is primary, adjust as needed)
get_primary_monitor() {
    xrandr --query | awk '/ connected primary/ {print $1}'
}

# Function to get the number of connected monitors
get_num_monitors() {
    xrandr --query | awk '/ connected/ {print $1}' | wc -l
}

# Function to assign workspaces to monitors
assign_workspaces() {
    local primary_monitor=$(get_primary_monitor)
    local num_monitors=$(get_num_monitors)
    local workspaces_per_monitor=$((${#workspace_names[@]} / num_monitors))
    local workspace_counter=0
    for monitor in $(xrandr --query | awk '/ connected/ {print $1}'); do
        local monitor_workspaces=("${workspace_names[@]:workspace_counter:workspaces_per_monitor}")
        bspc monitor "$monitor" -d "${monitor_workspaces[@]}"
        if [ "$monitor" != "$primary_monitor" ]; then
            xrandr --output "$monitor" --auto --right-of "$primary_monitor"
            primary_monitor="$monitor"
        fi
        workspace_counter=$((workspace_counter + workspaces_per_monitor))
    done
}

# Main loop to refresh the workspace assignment every 1800 seconds (30 minutes)
while true; do
    assign_workspaces
    sleep 5
done
