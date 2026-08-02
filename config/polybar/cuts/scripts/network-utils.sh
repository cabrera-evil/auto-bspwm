#!/usr/bin/env bash

set -euo pipefail

interface="${1:?interface is required}"
name="${2:?network name is required}"
icon="${3:?icon is required}"

ip="$(ip -o -4 addr show up dev "$interface" scope global 2>/dev/null | awk 'NR == 1 {print $4}' || true)"

# Do not reserve bar space for interfaces that are absent, down, or unaddressed.
if [[ -n "$ip" ]]; then
	printf '%s %s@%s\n' "$icon" "$name" "${ip%%/*}"
fi
