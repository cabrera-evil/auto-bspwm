#!/usr/bin/env bash

# Icons
ICON_ON=""
ICON_OFF=""

# Print usage help
print_help() {
	cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  status      Show current notification status (enabled/disabled)
  toggle      Toggle notification state
  help        Show this help message
EOF
}

# Get current notification status: "enabled" or "disabled"
get_status() {
	dunstctl is-paused | grep -q "false" && echo "enabled" || echo "disabled"
}

# Format status for CLI display with icon
print_status() {
	local status
	status=$(get_status)
	if [[ "$status" == "enabled" ]]; then
		echo "$ICON_ON"
	else
		echo "$ICON_OFF"
	fi
}

# Toggle notification state
toggle() {
	if dunstctl is-paused | grep -q "false"; then
		dunstctl set-paused true
	else
		dunstctl set-paused false
	fi
}

# Main CLI dispatcher
main() {
	case "$1" in
		status)
			print_status
			;;
		toggle)
			toggle
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
