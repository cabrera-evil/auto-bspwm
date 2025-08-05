#!/usr/bin/env bash

# Icons
ICON_ON=""
ICON_OFF=""

# Show usage
print_help() {
	cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  status      Show current microphone status (enabled/disabled)
  toggle      Toggle microphone capture (mute/unmute)
  help        Show this help message
EOF
}

# Get current mic status: "enabled" or "disabled"
get_status() {
	amixer sget Capture | awk -F'[][]' '
		/\[on\]/  { print "enabled"; exit }
		/\[off\]/ { print "disabled"; exit }
	'
}

# Print mic status with icon
print_status() {
	local status
	status=$(get_status)
	if [[ "$status" == "enabled" ]]; then
		echo "$ICON_ON"
	else
		echo "$ICON_OFF"
	fi
}

# Toggle mic capture
toggle() {
	amixer sset Capture toggle &>/dev/null
}

# Main CLI dispatcher
main() {
	case "$1" in
		status)
			print_status
			;;
		toggle)
			toggle
			print_status
			;;
		help | -h | --help | "")
			print_help
			;;
		*)
			echo "Unknown command: $1" >&2
			print_help
			exit 1
			;;
	esac
}

main "$@"
