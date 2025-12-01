#!/usr/bin/env bash
set -euo pipefail

PLAYER="spotify"
ICON_PLAY=""
ICON_PAUSE=""
ICON_PREV=""
ICON_NEXT=""
FORMAT="{{ title }} - {{ artist }}"
SCROLL_LENGTH=30
SCROLL_DELAY=0.1
SCROLL_PADDING=" "

show_help() {
	cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  status        Show play/pause icon or 'Offline'
  info          Run zscroll with current metadata or 'Offline'
  metadata      Internal: output metadata or 'Offline'
  prev          Show '' if Spotify is running
  next          Show '' if Spotify is running
  help          Show this help message

Examples:
  ${0##*/} status
  ${0##*/} info
EOF
}

get_status() {
	playerctl --player="$PLAYER" status 2>/dev/null || echo "Offline"
}

get_metadata() {
	local metadata
	metadata=$(playerctl --player="$PLAYER" metadata --format "$FORMAT" 2>/dev/null || echo "Offline")
	[[ "$metadata" == "Offline" ]] && echo " Offline" || echo " $metadata"
}

cmd_status() {
	case "$(get_status)" in
	Playing) echo "$ICON_PAUSE" ;;
	Paused) echo "$ICON_PLAY" ;;
	*) echo "" ;;
	esac
}

cmd_metadata() {
	get_metadata
}

cmd_info() {
	if command -v zscroll &>/dev/null; then
		zscroll -l "$SCROLL_LENGTH" \
			--delay "$SCROLL_DELAY" \
			--scroll-padding "$SCROLL_PADDING" \
			--match-command "$0 status" \
			--match-text "$ICON_PLAY" "--scroll 0" \
			--match-text "$ICON_PAUSE" "--scroll 1" \
			--match-text "Offline" "--scroll 0" \
			--update-check true "$0 metadata" &
		wait
	else
		cmd_metadata
	fi
}

cmd_prev() {
	[[ "$(get_status)" =~ Playing|Paused ]] && echo "$ICON_PREV" || echo ""
}

cmd_next() {
	[[ "$(get_status)" =~ Playing|Paused ]] && echo "$ICON_NEXT" || echo ""
}

main() {
	case "${1:-}" in
	status) cmd_status ;;
	info) cmd_info ;;
	metadata) cmd_metadata ;;
	prev) cmd_prev ;;
	next) cmd_next ;;
	help | "") show_help ;;
	*)
		echo "Unknown command: $1" >&2
		exit 1
		;;
	esac
}

main "$@"
