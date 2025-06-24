#!/usr/bin/env bash

# Path to the Polybar config
CONFIG="$HOME/.config/polybar/config.ini"
CHECK_INTERVAL=5

# Return the first active network interface (Wi-Fi or Ethernet)
get_active_network_interface() {
	nmcli -t -f DEVICE,STATE d | awk -F: '$2 == "connected"' | head -n1 | cut -d: -f1
}

# Launch Polybar on each connected monitor
launch_polybar() {
	killall -q polybar

	local net_iface
	net_iface="$(get_active_network_interface)"

	while IFS= read -r monitor; do
		MONITOR="$monitor" NETWORK_INTERFACE="$net_iface" polybar -q -c "$CONFIG" main &
	done < <(xrandr --query | awk '/ connected/ {print $1}')
}

# Main execution function
main() {
	launch_polybar

	local last_xrandr last_net current_xrandr current_net
	last_xrandr="$(xrandr --listmonitors)"
	last_net="$(get_active_network_interface)"

	while sleep "$CHECK_INTERVAL"; do
		current_xrandr="$(xrandr --listmonitors)"
		current_net="$(get_active_network_interface)"

		if [[ "$current_xrandr" != "$last_xrandr" || "$current_net" != "$last_net" ]]; then
			launch_polybar
			last_xrandr="$current_xrandr"
			last_net="$current_net"
		fi
	done
}

main "$@"
