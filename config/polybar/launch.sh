#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/polybar/config.ini"
CHECK_INTERVAL=5

# Get the first active network interface of a given type
get_interface_by_type() {
	local type="$1"
	nmcli -t -f DEVICE,STATE,TYPE d |
		awk -F: -v t="$type" '$2 == "connected" && $3 == t { print $1; exit }'
}

# Export env vars and launch polybar on each connected monitor
launch_polybar() {
	local wireless_iface wired_iface
	wireless_iface="$(get_interface_by_type wifi)"
	wired_iface="$(get_interface_by_type ethernet)"

	while IFS= read -r monitor; do
		MONITOR="$monitor" \
			WIRELESS_INTERFACE="$wireless_iface" \
			WIRED_INTERFACE="$wired_iface" \
			polybar -q -c "$CONFIG" main &
	done < <(xrandr --query | awk '/ connected/ {print $1}')
}

main() {
	launch_polybar

	local last_monitors last_wireless last_wired
	last_monitors="$(xrandr --listmonitors)"
	last_wireless="$(get_interface_by_type wifi)"
	last_wired="$(get_interface_by_type ethernet)"

	while sleep "$CHECK_INTERVAL"; do
		local current_monitors current_wireless current_wired
		current_monitors="$(xrandr --listmonitors)"
		current_wireless="$(get_interface_by_type wifi)"
		current_wired="$(get_interface_by_type ethernet)"

		if [[ "$current_monitors" != "$last_monitors" ||
			"$current_wireless" != "$last_wireless" ||
			"$current_wired" != "$last_wired" ]]; then
			launch_polybar
			last_monitors="$current_monitors"
			last_wireless="$current_wireless"
			last_wired="$current_wired"
		fi
	done
}

main "$@"
