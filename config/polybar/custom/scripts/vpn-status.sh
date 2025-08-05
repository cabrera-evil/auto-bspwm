#!/usr/bin/env bash

# Icon configuration (lock symbol)
ICON=""

# Return the first IP address for a given interface
get_ip() {
	local iface="$1"
	ip addr show "$iface" 2>/dev/null | awk '/inet / { sub(/\/.*/, "", $2); print $2; exit }'
}

# Format the output (no color)
format_output() {
	local iface="$1"
	local ip="$2"
	echo "$ICON $iface: $ip"
}

# Main execution function
main() {
	local found_iface=false
	local ip

	# WireGuard interfaces: wg*
	while IFS= read -r iface; do
		ip=$(get_ip "$iface" || true)
		ip=${ip:-"N/A"}
		format_output "$iface" "$ip"
		found_iface=true
	done < <(ip link show | awk -F: '/^[0-9]+: wg/ { gsub(/ /, "", $2); print $2 }')

	# Tailscale interface
	if ip link show tailscale0 &>/dev/null; then
		ip=$(get_ip "tailscale0" || true)
		ip=${ip:-"N/A"}
		format_output "tailscale0" "$ip"
		found_iface=true
	fi

	# Fallback if no interfaces found
	if ! $found_iface; then
		echo "$ICON N/A"
	fi
}

main "$@"
