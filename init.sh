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
	bat         # cat with syntax highlighting
	btop        # modern resource monitor (htop replacement)
	dos2unix    # convert text file formats (Windows ↔ Unix)
	fzf         # fuzzy finder for terminal
	htop        # process viewer
	jq          # JSON processor
	lsd         # modern ls alternative with icons
	neofetch    # system info tool
	python3-pip # Python package installer
	ranger      # terminal file manager
	ripgrep     # fast grep alternative
	rsync       # file sync tool
	scrub       # secure file wiping
	tmux        # terminal multiplexer
	xclip       # clipboard tool for X11
	yq          # YAML processor with jq-like syntax
	exa         # another modern ls alternative (if not using lsd)
	fd-find     # fast and user-friendly find replacement
	tree        # visual directory tree
	shellcheck  # shell script linter
	ncdu        # terminal disk usage analyzer
	trash-cli   # safe file deletion to trash
	unzip       # unzip utility
	zip         # archive utilities
	zoxide      # smarter directory jumper
)
DESKTOP_PACKAGES=(
	blueman                 # Bluetooth GUI manager
	bluez                   # Bluetooth protocol stack
	brightnessctl           # control screen brightness
	bspwm                   # tiling window manager
	bc                      # arbitrary precision calculator language
	cmatrix                 # Matrix terminal animation
	dunst                   # lightweight notification daemon
	exo-utils               # open files/URLs with default apps
	feh                     # image viewer, also used for wallpapers
	flameshot               # screenshot utility
	firejail                # sandbox for apps
	kitty                   # GPU-based terminal emulator
	i3lock-fancy            # screen locker with style
	imagemagick             # command-line image editor
	lxappearance            # GTK theme switcher
	numlockx                # enable Num Lock on startup
	numix-icon-theme        # icon theme
	numix-icon-theme-circle # icon theme variant
	pamixer                 # PulseAudio volume control
	picom                   # compositor (transparency, shadows)
	playerctl               # media control via CLI
	polybar                 # highly customizable status bar
	rofi                    # launcher and window switcher
	sxhkd                   # keybinding daemon (for bspwm)
	tty-clock               # terminal-based clock
	nitrogen                # wallpaper setter (alternative to feh)
	redshift                # night light color temperature adjuster
	xss-lock                # automatic screen lock based on X idle time
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

install_lazygit() {
	arch=$(uname -m)
	version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name":\s*"v\K[^"]+')
	local url

	command -v lazygit &>/dev/null && {
		log "lazygit already installed"
		return
	}
	log "Installing lazygit..."
	case "$arch" in
	x86_64) url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" ;;
	aarch64 | armv7l) url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_arm64.tar.gz" ;;
	*)
		abort "Unsupported architecture: $arch"
		;;
	esac
	curl -sL "$url" | tar xz -C /tmp lazygit
	sudo install /tmp/lazygit -D -t /usr/local/bin/
	success "lazygit installed successfully."
}

function install_tpm() {
	[[ -d "$HOME/.tmux/plugins/tpm" ]] || {
		log "Installing Tmux Plugin Manager..."
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
		success "Tmux Plugin Manager installed."
	}
}

function set_default_shell() {
	if [[ "$SHELL" != /usr/bin/zsh ]]; then
		log "Changing default shell to zsh..."
		chsh -s "$(which zsh)"
		sudo chsh -s "$(which zsh)" root
		success "Default shell changed to zsh."
	else
		log "Default shell is already zsh."
	fi
}

function set_default_terminal_emulator() {
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

function setup_wallpapers() {
	local wallpapers_dir="$HOME/Pictures/Wallpapers"
	log "Setting up wallpapers..."
	mkdir -p "$wallpapers_dir"
	cp -rv "$CURRENT_DIR/wallpapers/"* "$wallpapers_dir"
	wal -nqi "$wallpapers_dir/archkali.png" || warn "Failed to set wallpaper with pywal."
	success "Wallpapers set up successfully."
}

function setup_tz() {
	log "Setting timezone to ${TIMEZONE}..."
	sudo timedatectl set-timezone $TIMEZONE
	success "Timezone set to ${TIMEZONE}."
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
  cli           Install terminal tools (zsh, starship, tmux, lazygit, CLI packages)
  desktop       Install desktop packages and configs (bspwm, fonts, wallpapers)
  dotfiles      Apply dotfiles and symlinks (user + root)
  fonts         Install custom fonts
  tz            Set timezone to $TIMEZONE
  help          Show this help message
  version       Show script version
Examples:
  $SCRIPT_NAME all
EOF
}

function cmd_setup_all() {
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

function setup_cli_tools() {
	log "Installing CLI packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}"
	install_ohmyzsh
	install_starship
	install_tpm
	install_lazygit
	set_default_shell
	set_default_terminal_emulator
	setup_fonts
	setup_tz
	success "CLI tools installed successfully."
}

function setup_desktop_env() {
	local font_dir="$HOME/.local/share/fonts"
	local xorg_dir="/etc/X11/xorg.conf.d"

	log "Installing Desktop packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}"
	sudo pip3 install pywal --break-system
	sudo mkdir -p "$xorg_dir"
	sudo cp -rv "$CURRENT_DIR/xorg/"* "$xorg_dir"
	setup_fonts
	setup_wallpapers
	setup_tz
	success "Desktop environment configured successfully."
}

function cmd_dotfiles() {
	local config_dir="$HOME/.config"

	log "Applying dotfiles to user and root..."
	# Create symlinks for non-root user
	mkdir -p "$config_dir"
	ln -sfv "$CURRENT_DIR/config/"* "$config_dir/"
	ln -sfv "$CURRENT_DIR/.zshrc" "$HOME/.zshrc"
	ln -sfv "$CURRENT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
	ln -sfv "$CURRENT_DIR/.bashrc" "$HOME/.bashrc"
	# Copy dotfiles to root user
	sudo mkdir -p /root/.config
	sudo cp -rf "$config_dir/"* /root/.config/
	sudo cp -f "$CURRENT_DIR/.zshrc" /root/.zshrc
	sudo cp -f "$CURRENT_DIR/.p10k.zsh" /root/.p10k.zsh
	sudo cp -f "$CURRENT_DIR/.bashrc" /root/.bashrc
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

cmd_version() {
	echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

# ===================================
# MAIN LOGIC
# ===================================main() {
	local cmd="${1:-}"
	shift || true

	case "$cmd" in
	all) cmd_setup_all ;;
	cli) setup_cli_tools ;;
	desktop) setup_desktop_env ;;
	dotfiles) cmd_dotfiles ;;
	fonts) cmd_fonts ;;
	tz) setup_tz ;;
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
