#!/bin/bash

POLL_INTERVAL=120
LOW_BAT=33

BAT_PATH="/sys/class/power_supply/BAT0"
BAT_STAT="$BAT_PATH/status"

if [[ -f "$BAT_PATH/charge_full" ]]; then
	BAT_FULL="$BAT_PATH/charge_full"
	BAT_NOW="$BAT_PATH/charge_now"
elif [[ -f "$BAT_PATH/energy_full" ]]; then
	BAT_FULL="$BAT_PATH/energy_full"
	BAT_NOW="$BAT_PATH/energy_now"
else
	exit 1
fi

kill_running() {
	local mypid=$$
	pgrep -f "${0##*/}" | awk -v mypid="$mypid" '$1 != mypid { system("kill " $1) }'
}

launched=0
notify_id=9999 # arbitrary ID for dunstify --replace

if [[ -d "$BAT_PATH" ]]; then
	kill_running

	while :; do
		read -r bf <"$BAT_FULL"
		read -r bn <"$BAT_NOW"
		read -r bs <"$BAT_STAT"

		bat_percent=$((100 * bn / bf))

		case "$bs" in
		"Discharging")
			if ((bat_percent < LOW_BAT && launched < 3)); then
				dunstify --urgency=critical --replace="$notify_id" "$bat_percent% : Low Battery!"
				((launched++))
			fi
			;;
		"Charging")
			launched=0
			;;
		esac

		sleep "$POLL_INTERVAL"
	done
fi
