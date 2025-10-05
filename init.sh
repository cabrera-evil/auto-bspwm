#!/usr/bin/env bash
set -euo pipefail

# ===================================
# METADATA
# ===================================
readonly SCRIPT_NAME="$(basename "$0")"
readonly VERSION="1.0.0"

# ===================================
# COLORS
# ===================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	readonly RED=$'\033[0;31m'
	readonly GREEN=$'\033[0;32m'
	readonly YELLOW=$'\033[0;33m'
	readonly BLUE=$'\033[0;34m'
	readonly MAGENTA=$'\033[0;35m'
	readonly BOLD=$'\033[1m'
	readonly DIM=$'\033[2m'
	readonly NC=$'\033[0m'
else
	readonly RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi

# ===================================
# CONFIGURATION
# ===================================
DEBUG=false
QUIET=false
BASE_DIR=$(pwd)
USER=$(whoami)
TIMEZONE="America/El_Salvador"
CLI_PACKAGES=(
	atool             # archive extractor
	bat               # cat clone with syntax highlighting
	bluez             # bluetooth protocol stack
	bc                # precision calculator
	btop              # modern resource monitor
	brightnessctl     # control screen brightness
	chafa             # image-to-ascii converter (fallback for previews)
	cmatrix           # matrix-style terminal animation
	dos2unix          # convert text file line endings
	ffmpeg            # media processing and conversion
	fd-find           # fast and user-friendly find alternative
	highlight         # syntax highlighter (used in ranger previews)
	htop              # process viewer
	imagemagick       # image conversion and manipulation
	jq                # json processor
	lsd               # modern ls with icons and colors
	mediainfo         # display media metadata
	fastfetch         # system information tool
	ncdu              # terminal disk usage analyzer
	poppler-utils     # pdf text and metadata tools
	python3           # python interpreter
	python3-pip       # python package manager
	pipx              # python package installer for user-level packages
	playerctl         # media control from cli
	pamixer           # pulseaudio volume control
	ranger            # terminal file manager
	ripgrep           # fast recursive search (grep alternative)
	rsync             # file synchronization tool
	scrub             # secure file eraser
	screen            # terminal multiplexer (alternative to tmux)
	shellcheck        # shell script linter
	systemd-timesyncd # time synchronization service
	tmux              # terminal multiplexer
	trash-cli         # move files to trash
	tree              # recursive directory listing
	tty-clock         # terminal-based clock
	ueberzug          # image previews in terminal (for ranger)
	unzip             # unzip utility
	w3m               # terminal web browser (html preview fallback)
	xclip             # x11 clipboard manager
	yq                # yaml processor (jq-like syntax)
	zip               # archive utility
	zoxide            # smarter directory navigator
)
DESKTOP_PACKAGES=(
	arandr                  # gui for xrandr
	autorandr               # auto display profile loader
	blueman                 # gui bluetooth manager
	bspwm                   # tiling window manager
	dunst                   # lightweight notification daemon
	exo-utils               # open files and urls with default apps
	feh                     # image viewer and wallpaper setter
	flameshot               # screenshot tool
	firejail                # application sandboxing
	kitty                   # gpu-accelerated terminal
	i3lock-fancy            # stylish screen locker
	lxappearance            # gtk theme and icon manager
	numlockx                # enable num lock at startup
	numix-icon-theme-circle # numix circle icon variant
	mpd                     # music server
	picom                   # compositor (transparency, shadows)
	polybar                 # customizable status bar
	rofi                    # app launcher and window switcher
	sxhkd                   # simple hotkey daemon
	xss-lock                # auto screen lock based on inactivity
)

# ===================================
# LOGGING
# ===================================
log() { [[ "$QUIET" != true ]] && printf "${BLUE}▶${NC} %s\n" "$*" || true; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { [[ "$QUIET" != true ]] && printf "${GREEN}✓${NC} %s\n" "$*" || true; }
debug() { [[ "$DEBUG" == true ]] && printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2 || true; }
abort() {
	error "$*"
	exit 1
}

# ===================================
# UTILITIES
# ===================================
require_cmd() {
	command -v "$1" >/dev/null 2>&1 || abort "'$1' is not installed or not in PATH."
}

function install_ohmyzsh() {
	local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
	[[ -d "$HOME/.oh-my-zsh" ]] || {
		log "Installing Oh My Zsh..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	}
	declare -A plugins=(
		# UX Enhancements
		['zsh-autosuggestions']=https://github.com/zsh-users/zsh-autosuggestions
		['zsh-syntax-highlighting']=https://github.com/zsh-users/zsh-syntax-highlighting
		['zsh-history-substring-search']=https://github.com/zsh-users/zsh-history-substring-search
		['you-should-use']=https://github.com/MichaelAquilina/zsh-you-should-use
		['zsh-navigation-tools']=https://github.com/psprint/zsh-navigation-tools
		['zsh-autopair']=https://github.com/hlissner/zsh-autopair
		['zsh-ascii-art']=https://github.com/cabrera-evil/zsh-ascii-art
		['fzf-tab']=https://github.com/Aloxaf/fzf-tab
		# Git
		['git-open']=https://github.com/paulirish/git-open
	)
	for name in "${!plugins[@]}"; do
		[[ -d "$ZSH_CUSTOM/plugins/$name" ]] || git clone "${plugins[$name]}" "$ZSH_CUSTOM/plugins/$name"
	done
	[[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
	# Copy Oh My Zsh setup to root
	if [[ $EUID -ne 0 ]]; then
		sudo rsync -a --chown=root:root "$HOME/.oh-my-zsh" /root/
	fi
	success "Oh My Zsh plugins installed successfully."
}

function install_starship() {
	if command -v starship &>/dev/null; then
		log "Starship already installed"
		return
	fi
	log "Installing Starship..."
	curl -sS https://starship.rs/install.sh | sh -s -- --yes
	success "Starship installed successfully."
}

function install_tpm() {
	[[ -d "$HOME/.tmux/plugins/tpm" ]] || {
		log "Installing Tmux Plugin Manager..."
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
		success "Tmux Plugin Manager installed."
	}
}

install_zscroll() {
	if command -v zscroll &>/dev/null; then
		log "Zscroll already installed"
		return
	fi
	local tmp_dir
	tmp_dir=$(mktemp -d)
	git clone https://github.com/noctuid/zscroll "$tmp_dir/zscroll"
	cd "$tmp_dir/zscroll"
	sudo python3 setup.py install
}

install_fzf() {
	if command -v fzf &>/dev/null; then
		log "fzf already installed"
		return
	fi
	log "Installing fzf..."
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all
}

function setup_wallpapers() {
	local wallpapers_dir="$HOME/Pictures/Wallpapers"
	log "Setting up wallpapers..."
	mkdir -p "$wallpapers_dir"
	cp -rv "$BASE_DIR/wallpapers/"* "$wallpapers_dir"
	wal -nqi "$wallpapers_dir/archkali.png" || warn "Failed to set wallpaper with pywal."
	success "Wallpapers set up successfully."
}

function banner() {
	echo -e "${MAGENTA}              _____            ______"
	echo -e "______ ____  ___  /______      ___  /___________________      ________ ___"
	echo -e "_  __ \`/  / / /  __/  __ \     __  __ \_  ___/__  __ \_ | /| / /_  __ \`__ \\"
	echo -e "/ /_/ // /_/ // /_ / /_/ /     _  /_/ /(__  )__  /_/ /_ |/ |/ /_  / / / / /"
	echo -e "\__,_/ \__,_/ \__/ \____/      /_.___//____/ _  .___/____/|__/ /_/ /_/ /_/    ${NC}${YELLOW}(${NC}${GRAY}By ${NC}${PURPLE}@cabrera-evil${NC}${YELLOW})${NC}${TURQUOISE}"
	echo -e "                                             /_/${NC}"
}

# ===================================
# COMMANDS
# ===================================
function cmd_help() {
	cat <<EOF
${BOLD}${SCRIPT_NAME}${NC} - A script to bootstrap and configure your environment.

${BOLD}USAGE:${NC}
  $SCRIPT_NAME [OPTIONS] COMMAND

${BOLD}COMMANDS:${NC}
  ${GREEN}all${NC}            Run full environment setup
  ${GREEN}cli${NC}            Install terminal tools (zsh, starship, tmux, CLI packages)
  ${GREEN}desktop${NC}        Install desktop packages and configs (bspwm, fonts, wallpapers)
  ${GREEN}dotfiles${NC}       Apply dotfiles and symlinks (user + root)
  ${GREEN}fonts${NC}          Install custom fonts
  ${GREEN}tz${NC}             Set timezone to \$TIMEZONE
  ${GREEN}shell${NC}          Set default shell to 'zsh'
  ${GREEN}terminal${NC}       Set default terminal emulator to 'kitty'
  ${GREEN}help${NC}           Show this help message
  ${GREEN}version${NC}        Show script version

${BOLD}OPTIONS:${NC}
  ${YELLOW}-q, --quiet${NC}                  Minimize output
  ${YELLOW}-d, --debug${NC}                  Enable debug output
  ${YELLOW}-h, --help${NC}                   Show help
  ${YELLOW}-v, --version${NC}                Show version

${BOLD}EXAMPLES:${NC}
  # Run full environment setup
  $SCRIPT_NAME all
EOF
}

function cmd_all() {
	[[ "$USER" == "root" ]] && {
		banner
		abort "Do not run this as root!"
	}
	banner
	require_cmd git
	require_cmd curl
	cmd_cli
	cmd_desktop
	cmd_dotfiles
	cmd_fonts
	cmd_tz
	success "Environment configured successfully."
	read -rp "${TURQUOISE}Do you want to reboot now? (y/N):${NC} " reply
	if [[ "$reply" =~ ^[Yy]$ ]]; then
		success "Rebooting..."
		sudo reboot
	else
		success "Please reboot to apply changes."
	fi
}

function cmd_cli() {
	log "Installing CLI packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}"
	install_ohmyzsh
	install_starship
	install_tpm
	install_fzf
	success "CLI tools installed successfully."
}

function cmd_desktop() {
	local font_dir="$HOME/.local/share/fonts"
	local xorg_dir="/etc/X11/xorg.conf.d"
	log "Installing Desktop packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}"
	sudo pip3 install pywal --break-system
	sudo mkdir -p "$xorg_dir"
	sudo cp -rv "$BASE_DIR/xorg/"* "$xorg_dir"
	setup_wallpapers
	install_zscroll
	success "Desktop environment configured successfully."
}

function cmd_dotfiles() {
	local config_dir="$HOME/.config"
	log "Applying dotfiles to user and root..."
	# Backup old .zshrc if it exists
	if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
		local backup="$HOME/.zshrc.backup"
		mv "$HOME/.zshrc" "$backup"
		success "Backed up existing .zshrc to $backup"
	fi
	# Create symlinks for non-root user
	mkdir -p "$config_dir"
	ln -sfv "$BASE_DIR/.zshrc" "$HOME/.zshrc"
	ln -sfv "$BASE_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
	ln -sfv "$BASE_DIR/.bashrc" "$HOME/.bashrc"
	ln -sfv "$BASE_DIR/config/"* "$config_dir/"
	# Symlink dotfiles to root (forces override and keeps synced)
	sudo mkdir -p /root/.config
	sudo ln -sfv "$BASE_DIR/.zshrc" /root/.zshrc
	sudo ln -sfv "$BASE_DIR/.p10k.zsh" /root/.p10k.zsh
	sudo ln -sfv "$BASE_DIR/.bashrc" /root/.bashrc
	sudo ln -sfv "$BASE_DIR/config/"* /root/.config/
	success "Dotfiles applied successfully."
}

cmd_fonts() {
	local font_dir="$HOME/.local/share/fonts"
	log "Installing fonts..."
	mkdir -p "$font_dir"
	ln -sfn "$BASE_DIR/fonts" "$font_dir/custom-fonts"
	fc-cache -fv "$font_dir"
	success "Fonts installed successfully (symlink created)."
}

function cmd_tz() {
	log "Setting timezone to ${TIMEZONE}..."
	sudo timedatectl set-timezone "$TIMEZONE"
	success "Timezone set to ${TIMEZONE}."
	log "Configuring RTC to UTC..."
	sudo timedatectl set-local-rtc 0
	success "RTC set to UTC."
	log "Enabling NTP synchronization..."
	sudo timedatectl set-ntp true || {
		warning "NTP not available, trying to start systemd-timesyncd..."
		if command -v systemctl &>/dev/null; then
			sudo systemctl enable --now systemd-timesyncd || warning "systemd-timesyncd not installed."
		fi
	}
	success "NTP synchronization enabled."
	timedatectl
}

function cmd_default_shell() {
	if [[ "$SHELL" != /usr/bin/zsh ]]; then
		log "Changing default shell to zsh..."
		chsh -s "$(which zsh)"
		sudo chsh -s "$(which zsh)" root
		success "Default shell changed to zsh."
	else
		log "Default shell is already zsh."
	fi
}

function cmd_default_terminal_emulator() {
	kitty_path="$(command -v kitty)"
	local priority=100

	if [[ -z "$kitty_path" ]]; then
		warn "Kitty is not installed. Skipping terminal emulator setup."
		return
	fi
	if command -v x-terminal-emulator &>/dev/null; then
		if update-alternatives --query x-terminal-emulator 2>/dev/null | grep -q "$kitty_path"; then
			log "Removing existing kitty alternative..."
			sudo update-alternatives --remove x-terminal-emulator "$kitty_path"
		fi
		log "Installing kitty as x-terminal-emulator with priority $priority..."
		sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$kitty_path" "$priority"
		log "Setting kitty as default terminal emulator..."
		sudo update-alternatives --set x-terminal-emulator "$kitty_path"
		success "Kitty set as default terminal emulator."
	else
		warn "x-terminal-emulator is not available on this system."
	fi
}

cmd_version() {
	printf "%s %s\n" "$SCRIPT_NAME" "$VERSION"
}

# ===================================
# ARGUMENT PARSING
# ===================================
parse_arguments() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-q | --quiet)
			QUIET=true
			shift
			;;
		-d | --debug)
			DEBUG=true
			shift
			;;
		-h | --help)
			cmd_help
			exit 0
			;;
		-v | --version)
			cmd_version
			exit 0
			;;
		-*)
			abort "Unknown option: $1"
			;;
		*)
			shift
			;;
		esac
	done
}

# ===================================
# MAIN LOGIC
# ===================================
main() {
	local command="${1:-help}"
	parse_arguments "$@"

	case "$command" in
	all) cmd_all ;;
	cli) cmd_cli ;;
	desktop) cmd_desktop ;;
	dotfiles) cmd_dotfiles ;;
	fonts) cmd_fonts ;;
	tz) cmd_tz ;;
	shell) cmd_default_shell ;;
	terminal) cmd_default_terminal_emulator ;;
	help | "")
		cmd_help
		;;
	version)
		cmd_version
		;;
	*)
		abort "Unknown command: '$command'. Use '$SCRIPT_NAME help'."
		;;
	esac
}

main "$@"
