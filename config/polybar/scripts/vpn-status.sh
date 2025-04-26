#!/bin/bash

set -euo pipefail

# Function: Get the IP address of a given network interface
get_ip() {
	local iface="$1"
	ip addr show "$iface" 2>/dev/null | awk '/inet / { sub(/\/.*/, "", $2); print $2; exit }'
}

# Function: Format output with colors and icons
format_output() {
	local iface="$1"
	local ip="$2"
	local icon=""
	local color="#ffffff"
	printf "%%{F%s}%s %%{F%s}%s: %s %%{u-}\n" "$color" "$icon" "$color" "$iface" "$ip"
}

# Main logic: Detect WireGuard interfaces and display their IPs
found_iface=false
while read -r iface; do
	ip=$(get_ip "$iface")
	ip=${ip:-"N/A"}
	format_output "$iface" "$ip"
	found_iface=true
done < <(ip link show | awk -F: '/^[0-9]+: wg/ {gsub(/ /, "", $2); print $2}')

# If no WireGuard interfaces were found
if ! $found_iface; then
	printf "%%{F#ffffff}%%{u-} N/A\n"
fi
