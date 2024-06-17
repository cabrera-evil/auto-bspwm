#!/bin/sh

# Function to get the IP address of a given interface
get_ip() {
    ip addr show "$1" 2>/dev/null | awk '/inet /{sub(/\/.*/, "", $2); print $2; exit}'
}

# Get a list of interfaces excluding lo (loopback)
interfaces=$(ip link show | awk -F: '$0 !~ "lo|vir|^[^0-9]"{print $2;getline}')

# Loop through each interface and get its IP address
output=""
for iface in $interfaces; do
    ip=$(get_ip $iface)
    if [ -z "$ip" ]; then
        ip="No IP"
    fi
    output="$output %{F#ffffff} $iface: $ip %{u-}"
done

# Print the formatted output
echo "$output"