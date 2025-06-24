#!/usr/bin/env bash

# Configuration
workspace_names=(I II III IV V VI VII VIII IX X)
CHECK_INTERVAL=5

# Get all connected monitor names
get_monitors() {
	xrandr --query | awk '/ connected/ {print $1}'
}

# Get the name of the primary monitor
get_primary_monitor() {
	xrandr --query | awk '/ connected primary/ {print $1}'
}

# Assign workspaces evenly across monitors
assign_workspaces() {
	local monitors primary count per_monitor offset
	mapfile -t monitors < <(get_monitors)
	primary="$(get_primary_monitor)"
	count="${#monitors[@]}"
	per_monitor=$((${#workspace_names[@]} / count))
	offset=0

	for monitor in "${monitors[@]}"; do
		bspc monitor "$monitor" -d "${workspace_names[@]:offset:per_monitor}"

		if [[ "$monitor" != "$primary" && -n "$primary" ]]; then
			xrandr --output "$monitor" --auto --right-of "$primary"
		fi

		offset=$((offset + per_monitor))
	done
}

# Main function loop
main() {
	while sleep "$CHECK_INTERVAL"; do
		assign_workspaces
	done
}

main "$@"
