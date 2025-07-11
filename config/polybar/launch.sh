#!/usr/bin/env bash

# Path to the Polybar config
CONFIG="$HOME/.config/polybar/config.ini"
CHECK_INTERVAL=5

# Return the first active wireless network interface
get_wireless_interface() {
	nmcli -t -f DEVICE,STATE,TYPE d | awk -F: '$2 == "connected" && $3 == "wifi" {print $1; exit}'
}

# Return the first active wired network interface
get_wired_interface() {
	nmcli -t -f DEVICE,STATE,TYPE d | awk -F: '$2 == "connected" && $3 == "ethernet" {print $1; exit}'
}

# Launch Polybar on each connected monitor
launch_polybar() {
	killall -q polybar
	wireless_iface="$(get_wireless_interface)"
	wired_iface="$(get_wired_interface)"
	xrandr --query | awk '/ connected/ {print $1}' | while read -r monitor; do
		MONITOR="$monitor" WIRELESS_INTERFACE="$wireless_iface" WIRED_INTERFACE="$wired_iface" polybar -q -c "$CONFIG" main &
	done
}

# Main execution function
main() {
	launch_polybar
	last_xrandr=$(xrandr --listmonitors)
	last_wireless=$(get_wireless_interface)
	last_wired=$(get_wired_interface)
	while sleep "$CHECK_INTERVAL"; do
		if [[ "$(xrandr --listmonitors)" != "$last_xrandr" ||
		"$(get_wireless_interface)" != "$last_wireless" ||
		"$(get_wired_interface)" != "$last_wired" ]]; then
			launch_polybar
			last_xrandr=$(xrandr --listmonitors)
			last_wireless=$(get_wireless_interface)
			last_wired=$(get_wired_interface)
		fi
	done
}

main "$@"
