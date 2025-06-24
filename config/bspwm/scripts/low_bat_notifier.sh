#!/usr/bin/env bash

# Configuration
POLL_INTERVAL=120
LOW_BAT=33
NOTIFY_ID=9999
MAX_WARNINGS=3

# Detect the correct BAT* device
get_battery_path() {
	find /sys/class/power_supply/ -maxdepth 1 -type d -name "BAT*" | head -n1
}

# Kill other instances of this script
kill_running_instances() {
	local self_pid=$$
	pgrep -f "${0##*/}" | awk -v pid="$self_pid" '$1 != pid { system("kill " $1) }'
}

# Main monitor loop
main() {
	local BAT_PATH
	BAT_PATH="$(get_battery_path)"
	[[ -z "$BAT_PATH" ]] && echo "Battery not found" && exit 1

	local status_file="$BAT_PATH/status"
	local capacity_file="$BAT_PATH/capacity"
	local launched=0

	kill_running_instances

	while sleep "$POLL_INTERVAL"; do
		local percent status
		read -r percent <"$capacity_file"
		read -r status <"$status_file"

		if [[ "$status" == "Discharging" ]]; then
			if ((percent < LOW_BAT && launched < MAX_WARNINGS)); then
				dunstify --urgency=critical --replace="$NOTIFY_ID" "$percent% : Low Battery!"
				((launched++))
			fi
		elif [[ "$status" == "Charging" ]]; then
			launched=0
		fi
	done
}

main "$@"
