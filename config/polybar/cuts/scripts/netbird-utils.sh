#!/usr/bin/env bash

set -euo pipefail

IFACE="wt0"
ICON_ON="󰦝"
ICON_OFF="󱦚"

print_status() {
	local ip
	ip="$(ip -4 addr show dev "$IFACE" 2>/dev/null | awk '/inet / {print $2; exit}' || true)"

	if [[ -n "${ip:-}" ]]; then
		echo "$ICON_ON NetBird@${ip%%/*}"
	else
		echo "$ICON_OFF NetBird Offline"
	fi
}

main() {
	case "${1:-status}" in
	status)
		print_status
		;;
	*)
		print_status
		;;
	esac
}

main "${1:-status}"
