#!/bin/bash

# Function to get the IP address of a given interface
get_ip() {
    ip addr show "$1" 2>/dev/null | awk '/inet / {sub(/\/.*/, "", $2); print $2; exit}'
}

# Get all active network interfaces (Wi-Fi and Ethernet) using nmcli
active_interfaces=$(nmcli -t -f DEVICE,STATE d | awk -F: '$2 == "connected" {print $1}')

# Initialize output variable
output=""

# Loop through each active interface to retrieve its IP address
for iface in $active_interfaces; do
    ip=$(get_ip "$iface")
    if [ -n "$ip" ]; then
        output="$output%{F#ffffff} $iface: $ip %{u-}  "
    fi
done

# Print the formatted output
echo "$output"
