#!/bin/bash

# Function to get the IP address of a given interface
get_ip() {
    ip addr show "$1" 2>/dev/null | awk '/inet /{sub(/\/.*/, "", $2); print $2; exit}'
}

# Get a list of interfaces excluding lo (loopback)
interfaces=$(ip -o link show | awk '$2 !~ /^(lo|docker|vir)/{print $2}')

# Loop through each interface and get its IP address
output=""
for iface in $interfaces; do
    ip=$(get_ip $iface)
    if [ -z "$ip" ]; then
        ip="N/A"
    fi
    output="$output %{F#ffffff} $iface $ip %{u-}"
done

# Print the formatted output
echo "$output"
