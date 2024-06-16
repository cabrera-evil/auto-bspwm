#!/bin/sh

# Function to get the IP address of a given interface
get_ip() {
    ip addr show "$1" 2>/dev/null | awk '/inet /{sub(/\/.*/, "", $2); print $2; exit}'
}

# Get the IP addresses
wired_ip=$(get_ip enp2s0)
wireless_ip=$(get_ip wlo1)

# Default to "No IP" if no IP address is found
[ -z "$wired_ip" ] && wired_ip="No IP"
[ -z "$wireless_ip" ] && wireless_ip="No IP"

# Print the formatted output
echo "%{F#ffffff}  Wired: $wired_ip %{u-} %{F#ffffff}  Wireless: $wireless_ip %{u-}"
