#!/usr/bin/env bash

# Toggle Dunst notification state
toggle_notifications() {
	if dunstctl is-paused | grep -q "false"; then
		dunstctl set-paused true
	else
		dunstctl set-paused false
	fi
}

main() {
	toggle_notifications
}

main "$@"
