#!/usr/bin/env bash

workspace_names=(I II III IV V VI VII VIII IX X)

get_monitors() {
	readarray -t monitors < <(xrandr --query | awk '/ connected/ {print $1}')
	echo "${monitors[@]}"
}

get_primary_monitor() {
	xrandr --query | awk '/ connected primary/ {print $1}'
}

assign_workspaces() {
	local monitors=($(get_monitors))
	local primary=$(get_primary_monitor)
	local count=${#monitors[@]}
	local per_monitor=$((${#workspace_names[@]} / count))
	local offset=0

	for monitor in "${monitors[@]}"; do
		bspc monitor "$monitor" -d "${workspace_names[@]:offset:per_monitor}"

		if [[ "$monitor" != "$primary" ]]; then
			xrandr --output "$monitor" --auto --right-of "$primary"
		fi

		offset=$((offset + per_monitor))
	done
}

# Optional: clean up or log on exit
trap "echo 'Exiting workspace assignment script...'; exit 0" SIGINT SIGTERM

while :; do
	assign_workspaces
	sleep 5
done
