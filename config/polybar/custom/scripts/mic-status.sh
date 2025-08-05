#!/usr/bin/env bash

# Icons
ICON_ON=""
ICON_OFF=""

# Get capture status via amixer (returns "enabled" or "disabled")
get_mic_status() {
	amixer sget Capture | awk -F'[][]' '
        /\[on\]/  { print "enabled"; exit }
        /\[off\]/ { print "disabled"; exit }
    '
}

# Format output for bar or CLI
format_output() {
	local status="$1"
	if [[ "$status" == "enabled" ]]; then
		echo "$ICON_ON On"
	else
		echo "$ICON_OFF Off"
	fi
}

# Main function
main() {
	local status
	status="$(get_mic_status)"
	format_output "$status"
}

main "$@"
