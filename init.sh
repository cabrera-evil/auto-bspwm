#!/usr/bin/env bash
set -euo pipefail

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
CURRENT_DIR=$(pwd)
CLI_PACKAGES=(
	bat fzf btop htop kitty lsd neofetch python3-pip ranger rsync scrub tmux wmname xclip ripgrep dos2unix yq jq
)
DESKTOP_PACKAGES=(
	blueman bluez brightnessctl bspwm cmatrix dunst exo-utils feh flameshot firejail i3lock-fancy imagemagick
	lxappearance numlockx numix-icon-theme numix-icon-theme-circle pamixer polybar picom playerctl rofi sxhkd tty-clock
)

# ===================================
# COLOR CONFIGURATION
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
# UTILITIES
# ===================================
abort() {
	echo "ERROR: $1" >&2
	exit 1
}

info() {
	echo "INFO: $1"
}

success() {
	echo "SUCCESS: $1"
}

require_cmd() {
	command -v "$1" >/dev/null 2>&1 || abort "'$1' is not installed or not in PATH."
}

function header() {
	echo -e "${BLUE}==> $1${NC}"
	sleep 0.3
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
function install_ohmyzsh() {
	local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

	[[ -d "$HOME/.oh-my-zsh" ]] || {
		header "Installing Oh My Zsh..."
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
}

function install_starship() {
	if command -v starship &>/dev/null; then
		header "Starship already installed"
		return
	fi
	header "Installing Starship..."
	curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_lazygit() {
	local arch=$(uname -m)
	local version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name":\s*"v\K[^"]+')
	local url

	command -v lazygit &>/dev/null && {
		header "lazygit already installed"
		return
	}
	header "Installing lazygit..."
	case "$arch" in
	x86_64) url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" ;;
	aarch64 | armv7l) url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_arm64.tar.gz" ;;
	*)
		abort "Unsupported architecture: $arch"
		;;
	esac
	curl -sL "$url" | tar xz -C /tmp lazygit
	sudo install /tmp/lazygit -D -t /usr/local/bin/
}

function install_tpm() {
	[[ -d "$HOME/.tmux/plugins/tpm" ]] || {
		header "Installing Tmux Plugin Manager..."
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	}
}

function set_default_shell() {
	if [[ "$SHELL" != /usr/bin/zsh ]]; then
		header "Changing default shell to zsh..."
		chsh -s "$(which zsh)"
		sudo chsh -s "$(which zsh)" root
	else
		header "Default shell is already zsh."
	fi
}

function set_default_terminal_emulator() {
	local kitty_path="$(command -v kitty)"
	local priority=100

	if [[ -z "$kitty_path" ]]; then
		info "Kitty is not installed. Skipping terminal emulator setup."
		return
	fi
	if command -v x-terminal-emulator &>/dev/null; then
		if update-alternatives --query x-terminal-emulator 2>/dev/null | grep -q "$kitty_path"; then
			info "Removing existing kitty alternative..."
			sudo update-alternatives --remove x-terminal-emulator "$kitty_path"
		fi
		info "Installing kitty as x-terminal-emulator with priority $priority..."
		sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$kitty_path" "$priority"
		info "Setting kitty as default terminal emulator..."
		sudo update-alternatives --set x-terminal-emulator "$kitty_path"
	else
		abort "x-terminal-emulator is not available on this system."
	fi
}

function setup_cli_tools() {
	header "Installing CLI packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}"
	install_ohmyzsh
	install_starship
	install_tpm
	install_lazygit
	set_default_shell
	set_default_terminal_emulator
}

function setup_desktop_env() {
	local font_dir="$HOME/.local/share/fonts"
	local xorg_dir="/etc/X11/xorg.conf.d"

	header "Installing Desktop packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}"
	sudo pip3 install pywal --break-system
	mkdir -p "$font_dir"
	cp -rv "$CURRENT_DIR/fonts/"* "$font_dir"
	mkdir -p "$HOME/Pictures/Wallpapers"
	cp -rv "$CURRENT_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers"
	wal -nqi "$HOME/Pictures/Wallpapers/archkali.png"
	sudo mkdir -p "$xorg_dir"
	sudo cp -rv "$CURRENT_DIR/xorg/"* "$xorg_dir"
	sudo timedatectl set-timezone America/El_Salvador
}

function apply_dotfiles() {
	local config_dir="$HOME/.config"

	header "Applying dotfiles to user and root..."
	mkdir -p "$config_dir"
	ln -sfv "$CURRENT_DIR/config/"* "$config_dir/"
	ln -sfv "$CURRENT_DIR/.zshrc" "$HOME/.zshrc"
	ln -sfv "$CURRENT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
	ln -sfv "$CURRENT_DIR/.bashrc" "$HOME/.bashrc"

	sudo mkdir -p /root/.config
	sudo cp -rf "$config_dir/"* /root/.config/
	sudo cp -f "$CURRENT_DIR/.zshrc" /root/.zshrc
	sudo cp -f "$CURRENT_DIR/.p10k.zsh" /root/.p10k.zsh
	sudo cp -f "$CURRENT_DIR/.bashrc" /root/.bashrc
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
	apply_dotfiles
	success "✔ Environment configured successfully."
	read -rp "${TURQUOISE}Do you want to reboot now? (y/N):${NC} " reply
	if [[ "$reply" =~ ^[Yy]$ ]]; then
		success "Rebooting..."
		sudo reboot
	else
		success "Please reboot to apply changes."
	fi
}

# ===================================
# MAIN LOGIC
# ===================================
function show_help() {
	cat <<EOF
Usage: $SCRIPT_NAME <command>

Commands:
  all           Run full environment setup
  cli           Install terminal tools (zsh, starship, tmux, lazygit, CLI packages)
  desktop       Install desktop packages and configs (bspwm, fonts, wallpapers)
  dotfiles      Apply dotfiles and symlinks (user + root)
  help          Show this help message
  version       Show script version
Examples:
  $SCRIPT_NAME all
EOF
}

main() {
	local cmd="${1:-}"
	shift || true

	case "$cmd" in
	all) cmd_setup_all ;;
	cli) setup_cli_tools ;;
	desktop) setup_desktop_env ;;
	dotfiles) apply_dotfiles ;;
	help | "")
		show_help
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
