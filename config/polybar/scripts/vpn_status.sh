#!/bin/sh

# Check if the tun0 interface exists
IFACE=$(ip link show tun0 2>/dev/null | awk '{print $2}' | tr -d ':')

if [ "$IFACE" = "tun0" ]; then
	# Get the IP address of tun0
	IP=$(ip addr show tun0 | awk '/inet /{print $2}' | cut -d/ -f1)
	echo "%{F#ffffff}  %{F#ffffff}$IP%{u-}"
else
	echo "%{F#ffffff} %{u-} Disconnected"
fi
