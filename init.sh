#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
TURQUOISE='\e[0;36m'
GRAY='\e[0;37m'
NC='\e[0m'

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SCRIPT_NAME="$(basename "$0")"
SCRIPT_VERSION="1.0.0"
DEBUG=false
SILENT=false

# ===================================
# DEFAULT CONFIGURATION
# ===================================
USER=$(whoami)
TIMEZONE="America/El_Salvador"
CURRENT_DIR=$(pwd)
CLI_PACKAGES=(
	atool         # archive extractor
	bat           # cat clone with syntax highlighting
	bluez         # bluetooth protocol stack
	bc            # precision calculator
	btop          # modern resource monitor
	brightnessctl # control screen brightness
	chafa         # image-to-ascii converter (fallback for previews)
	cmatrix       # matrix-style terminal animation
	dos2unix      # convert text file line endings
	ffmpeg        # media processing and conversion
	fzf           # fuzzy finder for terminal
	fd-find       # fast and user-friendly find alternative
	highlight     # syntax highlighter (used in ranger previews)
	htop          # process viewer
	imagemagick   # image conversion and manipulation
	jq            # json processor
	lsd           # modern ls with icons and colors
	mediainfo     # display media metadata
	neofetch      # system information tool
	ncdu          # terminal disk usage analyzer
	poppler-utils # pdf text and metadata tools
	python3-pip   # python package manager
	playerctl     # media control from cli
	pamixer       # pulseaudio volume control
	ranger        # terminal file manager
	ripgrep       # fast recursive search (grep alternative)
	rsync         # file synchronization tool
	scrub         # secure file eraser
	screen        # terminal multiplexer (alternative to tmux)
	shellcheck    # shell script linter
	tmux          # terminal multiplexer
	trash-cli     # move files to trash
	tree          # recursive directory listing
	tty-clock     # terminal-based clock
	ueberzug      # image previews in terminal (for ranger)
	unzip         # unzip utility
	w3m           # terminal web browser (html preview fallback)
	xclip         # x11 clipboard manager
	yq            # yaml processor (jq-like syntax)
	zip           # archive utility
	zoxide        # smarter directory navigator
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
log() {
	if [ "$SILENT" != "true" ]; then
		echo -e "${BLUE}==> $1${NC}"
	fi
}
warn() {
	if [ "$SILENT" != "true" ]; then
		echo -e "${YELLOW}⚠️  $1${NC}" >&2
	fi
}
success() {
	if [ "$SILENT" != "true" ]; then
		echo -e "${GREEN}✓ $1${NC}"
	fi
}
abort() {
	if [ "$SILENT" != "true" ]; then
		echo -e "${RED}✗ $1${NC}" >&2
	fi
	exit 1
}
debug() {
	if [ "$DEBUG" = "true" ]; then
		echo -e "${MAGENTA}🐞 DEBUG: $1${NC}"
	fi
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

function setup_wallpapers() {
	local wallpapers_dir="$HOME/Pictures/Wallpapers"
	log "Setting up wallpapers..."
	mkdir -p "$wallpapers_dir"
	cp -rv "$CURRENT_DIR/wallpapers/"* "$wallpapers_dir"
	wal -nqi "$wallpapers_dir/archkali.png" || warn "Failed to set wallpaper with pywal."
	success "Wallpapers set up successfully."
}

function banner() {
	echo -e "${TURQUOISE}              _____            ______"
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
Usage: $SCRIPT_NAME <command>

Commands:
  all           Run full environment setup
  cli           Install terminal tools (zsh, starship, tmux, CLI packages)
  desktop       Install desktop packages and configs (bspwm, fonts, wallpapers)
  dotfiles      Apply dotfiles and symlinks (user + root)
  fonts         Install custom fonts
  tz            Set timezone to $TIMEZONE
  shell         Set default shell to 'zsh'
  terminal      Set default terminal emulator to 'kitty'
  help          Show this help message
  version       Show script version
Examples:
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
	setup_cli_tools
	setup_desktop_env
	cmd_dotfiles
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
	cmd_fonts
	cmd_tz
	success "CLI tools installed successfully."
}

function cmd_desktop() {
	local font_dir="$HOME/.local/share/fonts"
	local xorg_dir="/etc/X11/xorg.conf.d"

	log "Installing Desktop packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}"
	sudo pip3 install pywal --break-system
	sudo mkdir -p "$xorg_dir"
	sudo cp -rv "$CURRENT_DIR/xorg/"* "$xorg_dir"
	setup_wallpapers
	cmd_fonts
	cmd_tz
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
	ln -sfv "$CURRENT_DIR/.zshrc" "$HOME/.zshrc"
	ln -sfv "$CURRENT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
	ln -sfv "$CURRENT_DIR/.bashrc" "$HOME/.bashrc"
	ln -sfv "$CURRENT_DIR/config/"* "$config_dir/"

	# Symlink dotfiles to root (forces override and keeps synced)
	sudo mkdir -p /root/.config
	sudo ln -sfv "$CURRENT_DIR/.zshrc" /root/.zshrc
	sudo ln -sfv "$CURRENT_DIR/.p10k.zsh" /root/.p10k.zsh
	sudo ln -sfv "$CURRENT_DIR/.bashrc" /root/.bashrc
	sudo ln -sfv "$CURRENT_DIR/config/"* /root/.config/

	success "Dotfiles applied successfully."
}

function cmd_fonts() {
	local font_dir="$HOME/.local/share/fonts"
	log "Installing fonts..."
	mkdir -p "$font_dir"
	cp -rv "$CURRENT_DIR/fonts/"* "$font_dir"
	fc-cache -fv "$font_dir"
	success "Fonts installed successfully."
}

function cmd_tz() {
	log "Setting timezone to ${TIMEZONE}..."
	sudo timedatectl set-timezone $TIMEZONE
	success "Timezone set to ${TIMEZONE}."
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
	echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

# ===================================
# MAIN LOGIC
# ===================================
main() {
	local cmd="${1:-}"
	shift || true

	case "$cmd" in
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
		abort "Unknown command: $cmd. Use '$SCRIPT_NAME help' to list available commands."
		;;
	esac
}

main "$@"
