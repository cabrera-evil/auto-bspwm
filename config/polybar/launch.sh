#!/usr/bin/env bash
set -euo pipefail

# =============================
# COLORS
# =============================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
NC='\e[0m'

# =============================
# CONFIG
# =============================
SCRIPT_NAME="$(basename "$0")"
SCRIPT_VERSION="1.0.0"
DEBUG=false
SILENT=false
CONFIG_DIR="$HOME/.config/polybar"
CHECK_INTERVAL="${CHECK_INTERVAL:-5}"

# =============================
# LOGGING
# =============================
log() { [[ $SILENT != true ]] && echo -e "${BLUE}==> $1${NC}"; }
warn() { [[ $SILENT != true ]] && echo -e "${YELLOW}⚠️  $1${NC}" >&2; }
success() { [[ $SILENT != true ]] && echo -e "${GREEN}✓ $1${NC}"; }
abort() {
	[[ $SILENT != true ]] && echo -e "${RED}✗ $1${NC}" >&2
	exit 1
}
debug() { [[ $DEBUG == true ]] && echo -e "${MAGENTA}🐞 DEBUG: $1${NC}"; }

# =============================
# HELPERS
# =============================
require_cmd() { command -v "$1" >/dev/null 2>&1 || abort "'$1' is not installed."; }

get_interface_by_type() {
	nmcli -t -f DEVICE,STATE,TYPE device | awk -F: -v t="$1" '$2 == "connected" && $3 == t { print $1; exit }'
}

list_themes() {
	for dir in "$CONFIG_DIR"/*; do [[ -d "$dir" ]] && basename "$dir"; done
}

choose_theme() {
	require_cmd fzf
	local selected
	selected=$(list_themes | sort | fzf --prompt="Select a theme: ")
	[[ -z "$selected" ]] && abort "No theme selected."
	echo "$selected"
}

launch_polybar() {
	local theme="$1"
	local theme_dir="$CONFIG_DIR/$theme"
	local config_file="$theme_dir/config.ini"
	[[ -f "$config_file" ]] || config_file="$theme_dir/bars.ini"
	[[ -f "$config_file" ]] || abort "Theme '$theme' lacks config.ini or bars.ini"

	if [[ "$theme" == "pwidgets" ]]; then
		bash "$theme_dir/launch.sh" --main
		success "Launched pwidgets via its own script"
		return
	fi

	pkill -x polybar || true
	sleep 2

	local wifi_iface ethernet_iface
	wifi_iface=$(get_interface_by_type wifi)
	ethernet_iface=$(get_interface_by_type ethernet)

	xrandr --query | awk '/ connected/ {print $1}' | while read -r monitor; do
		for bar in top bottom; do
			MONITOR="$monitor" \
				WIRELESS_INTERFACE="$wifi_iface" \
				WIRED_INTERFACE="$ethernet_iface" \
				polybar -q "$bar" -c "$config_file" &
		done
	done

	success "Launched polybar: top + bottom for '$theme' on all monitors"
}

watch_for_changes() {
	local theme="$1" last_mon last_wifi last_wired is_restarting=false
	last_mon=$(xrandr --listmonitors)
	last_wifi=$(get_interface_by_type wifi)
	last_wired=$(get_interface_by_type ethernet)

	while sleep "$CHECK_INTERVAL"; do
		local cur_mon cur_wifi cur_wired
		cur_mon=$(xrandr --listmonitors)
		cur_wifi=$(get_interface_by_type wifi)
		cur_wired=$(get_interface_by_type ethernet)

		if [[ "$is_restarting" == false && ("$cur_mon" != "$last_mon" || "$cur_wifi" != "$last_wifi" || "$cur_wired" != "$last_wired") ]]; then
			is_restarting=true
			log "Change detected. Relaunching Polybar..."
			launch_polybar "$theme"
			last_mon="$cur_mon"
			last_wifi="$cur_wifi"
			last_wired="$cur_wired"
			sleep 2
			is_restarting=false
		fi
	done
}

cmd_help() {
	cat <<EOF
Usage: $SCRIPT_NAME [--theme <name>] [--watch] [--interval <sec>] [--silent] [--debug] [--help]

Options:
  --theme <name>   Launch specific theme directly
  --watch          Re-launch on monitor/network interface change
  --interval <n>   Set check interval in seconds (default: $CHECK_INTERVAL)
  --silent         Disable output
  --debug          Enable debug logs
  --help, -h       Show this help message
  --version, -v    Show script version

If --theme is not provided, an interactive selector will launch.
EOF
}

cmd_version() {
	echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

main() {
	local theme="" watch_mode=false
	require_cmd polybar
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--theme)
			shift
			theme="$1"
			;;
		--watch) watch_mode=true ;;
		--interval)
			shift
			[[ "$1" =~ ^[0-9]+$ ]] || abort "Invalid interval"
			CHECK_INTERVAL="$1"
			;;
		--silent) SILENT=true ;;
		--debug) DEBUG=true ;;
		--help | -h)
			cmd_help
			exit 0
			;;
		--version | -v)
			cmd_version
			exit 0
			;;
		*) abort "Unknown argument: $1" ;;
		esac
		shift
	done
	[[ -z "$theme" ]] && log "No theme specified. Launching selector..." && theme="$(choose_theme)"
	theme_exists "$theme" || abort "Invalid theme: $theme"
	launch_polybar "$theme"
	[[ "$watch_mode" == true ]] && watch_for_changes "$theme" &
	wait
}

main "$@"
