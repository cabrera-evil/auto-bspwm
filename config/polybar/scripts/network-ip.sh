#!/bin/bash

# Function to get the IP address of a given interface
get_ip() {
    ip addr show "$1" 2>/dev/null | awk '/inet /{sub(/\/.*/, "", $2); print $2; exit}'
}

# Get a list of active interfaces that are connected to Wi-Fi
active_interfaces=$(nmcli -t -f active,device dev wifi | egrep '^yes' | cut -d':' -f2)

# Loop through each active Wi-Fi interface and get its IP address
output=""
for iface in $active_interfaces; do
    ip=$(get_ip $iface)
    if [ -n "$ip" ]; then
        output="$output %{F#ffffff} $iface: $ip %{u-}"
    fi
done

# Print the formatted output
echo "$output"
