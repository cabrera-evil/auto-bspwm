#!/usr/bin/env bash

# Get the first IP of a given network interface
get_ip() {
	local iface="$1"
	ip addr show "$iface" 2>/dev/null | awk '/inet / { sub(/\/.*/, "", $2); print $2; exit }'
}

# Format interface and IP for plain output
format_output() {
	local iface="$1"
	local ip="$2"
	echo "$iface: $ip"
}

# Main execution
main() {
	local iface ip
	local active_interfaces output=""

	active_interfaces=$(nmcli -t -f DEVICE,STATE d | awk -F: '$2 == "connected" {print $1}')

	for iface in $active_interfaces; do
		ip=$(get_ip "$iface")
		[[ -n "$ip" ]] && output+=$(format_output "$iface" "$ip")$'\n'
	done

	# Remove trailing newline if any and print
	[[ -n "$output" ]] && echo -n "$output"
}

main "$@"
