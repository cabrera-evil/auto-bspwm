#!/usr/bin/env bas:

# Workspace (desktop) names
workspace_names=(I II III IV V VI VII VIII IX X)

main() {
	# Get current connected monitors from bspwm (not xrandr)
	mapfile -t monitors < <(bspc query -M)

	local count="${#monitors[@]}"
	local per_monitor=$((${#workspace_names[@]} / count))
	local offset=0

	for monitor in "${monitors[@]}"; do
		bspc monitor "$monitor" -d "${workspace_names[@]:offset:per_monitor}"
		offset=$((offset + per_monitor))
	done
}

main "$@"
