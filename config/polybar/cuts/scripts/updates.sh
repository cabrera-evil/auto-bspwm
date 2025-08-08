#!/usr/bin/env bash
set -euo pipefail

NOTIFY_ICON="system-software-update"
NOTIFY_ID=2593

get_updates() {
	apt list --upgradable 2>/dev/null | grep -c "upgradable"
}

notify() {
	local message="$1"
	local urgency="${2:-normal}"
	command -v dunstify &>/dev/null || return 0
	dunstify -r "$NOTIFY_ID" -u "$urgency" -i "$NOTIFY_ICON" "APT Updater" "$message"
}

show_help() {
	cat <<EOF
Usage: $(basename "$0") <command> [options]

Commands:
  check [--watch]     Show number of available updates. If --watch is set, keep checking.
  update              Run apt update & upgrade. Notify when done.
  help                Show this help message.

Examples:
  ${0##*/} check
  ${0##*/} check --watch
  ${0##*/} update
EOF
}

cmd_check() {
	local count
	count=$(get_updates)

	if ((count > 0)); then
		echo " $count"
		notify "$count updates available" "normal"
	else
		echo " None"
	fi
}

cmd_update() {
	echo "Updating packages..."
	sudo apt update
	sudo apt upgrade -y
	echo "Update finished"
	notify "System updated successfully" "low"
}

main() {
	case "${1:-}" in
	check)
		shift
		cmd_check "$@"
		;;
	update) cmd_update ;;
	help | "") show_help ;;
	*) echo "Unknown command: $1" ;;
	esac
}

main "$@"
