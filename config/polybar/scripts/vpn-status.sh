#!/bin/bash

# Function to get the IP address of a given interface
get_ip() {
	ip addr show "$1" 2>/dev/null | awk '/inet /{sub(/\/.*/, "", $2); print $2; exit}'
}

# Check if the tun0 interface exists
interface=$(ip link show tun0 2>/dev/null | awk '{print $2}' | tr -d ':')

# If the interface exists, get its IP address
output=""
if [ "$interface" = "tun0" ]; then
	ip=$(get_ip tun0)
	if [ -z "$ip" ]; then
		ip="N/A"
	fi
	output="%{F#ffffff}  %{F#ffffff} $ip %{u-}"
else
	output="%{F#ffffff} %{u-} Disconnected"
fi

# Print the formatted output
echo "$output"
