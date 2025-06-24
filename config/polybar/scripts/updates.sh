#!/usr/bin/env bash

# Configuration
NOTIFY_ICON="/usr/share/icons/Numix-Circle/48@2x/apps/system-software-update.svg"
NOTIFY_ID=2593
POLL_NO_UPDATES=1800 # 30 minutes
POLL_WITH_UPDATES=5  # 5 seconds

# Return the number of available APT updates
get_total_updates() {
	apt list --upgradable 2>/dev/null | grep -c "upgradable"
}

# Show a notification based on how many updates are available
send_notification() {
	local count="$1"

	if ! command -v dunstify &>/dev/null; then
		return
	fi

	if ((count >= 100)); then
		urgency="critical"
		title="You really need to update!!"
	elif ((count >= 20)); then
		urgency="normal"
		title="You should update soon"
	elif ((count >= 3)); then
		urgency="low"
		title="You have updates"
	else
		return
	fi

	dunstify -r "$NOTIFY_ID" -u "$urgency" -i "$NOTIFY_ICON" "$title" "$count New packages"
}

# Main loop
main() {
	while true; do
		local updates
		updates=$(get_total_updates)
		send_notification "$updates"

		if ((updates > 0)); then
			while ((updates > 0)); do
				echo " $updates"
				sleep "$POLL_WITH_UPDATES"
				updates=$(get_total_updates)
			done
		else
			echo " None"
			sleep "$POLL_NO_UPDATES"
		fi
	done
}

main "$@"
