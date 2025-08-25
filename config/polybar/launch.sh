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
	nmcli -t -f DEVICE,STATE,TYPE device | awk -F: -v t="$1" '$3 == t { print $1; exit }'
}

get_monitors() {
	xrandr --query | awk '/ connected/ {print $1}'
}

list_themes() {
	for dir in "$CONFIG_DIR"/*; do
		[[ -d "$dir" ]] || continue
		basename "$dir"
	done
}

theme_exists() {
	[[ -d "$CONFIG_DIR/$1" ]] && return 0 || return 1
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
	local config="$theme_dir/config.ini"
	local fallback="$theme_dir/bars.ini"
	local bars=(top bottom)
	local wifi_iface ethernet_iface
	wifi_iface=$(get_interface_by_type wifi)
	ethernet_iface=$(get_interface_by_type ethernet)

	local config_file=""
	if [[ -f "$config" ]]; then
		config_file="$config"
	elif [[ -f "$fallback" ]]; then
		config_file="$fallback"
	else
		abort "Theme '$theme' does not contain config.ini or bars.ini"
	fi

	pkill -x polybar &>/dev/null && sleep 1

	get_monitors | while read -r monitor; do
		for bar in "${bars[@]}"; do
			MONITOR="$monitor" \
				WIRELESS_INTERFACE="$wifi_iface" \
				WIRED_INTERFACE="$ethernet_iface" \
				polybar -q "$bar" -c "$config_file" &
		done
	done

	success "Launched polybar: ${bars[*]} bars for theme '$theme' on all monitors"
}

watch_for_changes() {
	local theme="$1"
	local last_mon
	last_mon=$(get_monitors)

	while sleep "$CHECK_INTERVAL"; do
		local cur_mon
		cur_mon=$(get_monitors)
		if [[ "$cur_mon" != "$last_mon" ]]; then
			log "Monitor change detected. Relaunching Polybar..."
			launch_polybar "$theme"
			last_mon="$cur_mon"
		fi
	done
}

cmd_help() {
	cat <<EOF
Usage: $SCRIPT_NAME [--theme <name>] [--watch] [--silent] [--debug] [--help]

Options:
  --theme <name>   Launch specific theme directly
  --watch          Re-launch on monitor/network interface change
  --inverval       Set check interval in seconds (default: $CHECK_INTERVAL)
  --silent         Disable output
  --debug          Enable debug logs
  --help           Show this help message
  --version        Show script version

If --theme is not provided, an interactive selector will launch.
EOF
}

cmd_version() {
	echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

main() {
	local theme=""
	local watch_mode=false

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--theme)
			shift || abort "Missing theme name after --theme"
			theme="$1"
			;;
		--watch) watch_mode=true ;;
		--interval)
			shift
			[[ "$1" =~ ^[0-9]+$ ]] || abort "Invalid interval: must be a number"
			CHECK_INTERVAL="$1"
			;;
		--silent) SILENT=true ;;
		--debug) DEBUG=true ;;
		--help | -h | '')
			cmd_help
			;;
		--version | -v)
			cmd_version
			;;
		*) abort "Unknown argument: $1" ;;
		esac
		shift
	done

	if [[ -z "$theme" ]]; then
		log "No theme specified. Launching selector..."
		theme="$(choose_theme)"
	fi

	theme_exists "$theme" || abort "Invalid theme: $theme"
	launch_polybar "$theme"
	[[ "$watch_mode" == true ]] && watch_for_changes "$theme"
}

main "$@"
