#!/bin/bash

# Function to get the IP address of a given iface
get_ip() {
	ip addr show "$1" 2>/dev/null | awk '/inet /{sub(/\/.*/, "", $2); print $2; exit}'
}

# Check if the wg0 iface exists
iface=$(ip link show wg0 2>/dev/null | awk '{print $2}' | tr -d ':')

# If the iface exists, get its IP address
output=""
if [ "$iface" = "wg0" ]; then
	ip=$(get_ip wg0)
	if [ -z "$ip" ]; then
		ip="N/A"
	fi
	output="%{F#ffffff}%{F#ffffff} $iface: $ip %{u-}"
else
	output="%{F#ffffff}%{u-} N/A"
fi

# Print the formatted output
echo "$output"
