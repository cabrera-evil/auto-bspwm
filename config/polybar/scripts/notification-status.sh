#!/usr/bin/env bash

# Icons
ICON_ON=""
ICON_OFF=""

# Check if Dunst notifications are paused
get_notification_status() {
	dunstctl is-paused | grep -q "false" && echo "enabled" || echo "disabled"
}

# Format the output
format_output() {
	local status="$1"
	if [[ "$status" == "enabled" ]]; then
		echo "$ICON_ON On"
	else
		echo "$ICON_OFF Off"
	fi
}

# Main execution
main() {
	local status
	status="$(get_notification_status)"
	format_output "$status"
}

main "$@"
