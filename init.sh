#!/usr/bin/env bash

set -euo pipefail

# -------------------------
# Defaults
# -------------------------
USER=$(whoami)
CURRENT_DIR=$(pwd)
FONT_DIR="$HOME/.local/share/fonts"
XORG_DIR="/etc/X11/xorg.conf.d"
CONFIG_DIR="$HOME/.config"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

CLI_PACKAGES=(
	bat fzf htop kitty lsd neofetch python3-pip ranger rsync scrub tmux wmname xclip
)

DESKTOP_PACKAGES=(
	blueman bluez brightnessctl bspwm cmatrix dunst exo-utils feh flameshot firejail i3lock-fancy imagemagick
	lxappearance numlockx numix-icon-theme numix-icon-theme-circle pamixer polybar picom playerctl rofi sxhkd tty-clock
)

# -------------------------
# Colors
# -------------------------
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
TURQUOISE='\e[0;36m'
GRAY='\e[0;37m'
NC='\e[0m'

# -------------------------
# Helper Functions
# -------------------------
function usage() {
	cat <<EOF
Usage: $(basename "$0") [command]

Commands:
  all           Run full environment setup
  cli           Install terminal tools (zsh, starship, tmux, lazygit, CLI packages)
  desktop       Install desktop packages and configs (bspwm, fonts, wallpapers)
  dotfiles      Apply dotfiles and symlinks (user + root)
  help                Show this help message
EOF
}

function header() {
	echo -e "${BLUE}==> $1${NC}"
	sleep 0.3
}

function require_cmd() {
	command -v "$1" >/dev/null 2>&1 || {
		echo -e "${RED}❌ '$1' is not installed.${NC}"
		exit 1
	}
}

function banner() {
	echo -e "${TURQUOISE}              _____            ______"
	echo -e "______ ____  ___  /______      ___  /___________________      ________ ___"
	echo -e "_  __ \`/  / / /  __/  __ \     __  __ \_  ___/__  __ \_ | /| / /_  __ \`__ \\"
	echo -e "/ /_/ // /_/ // /_ / /_/ /     _  /_/ /(__  )__  /_/ /_ |/ |/ /_  / / / / /"
	echo -e "\__,_/ \__,_/ \__/ \____/      /_.___//____/ _  .___/____/|__/ /_/ /_/ /_/    ${NC}${YELLOW}(${NC}${GRAY}By ${NC}${PURPLE}@cabrera-evil${NC}${YELLOW})${NC}${TURQUOISE}"
	echo -e "                                             /_/${NC}"
}

# -------------------------
# Install CLI tools
# -------------------------
function install_ohmyzsh() {
	[[ -d "$HOME/.oh-my-zsh" ]] || {
		header "Installing Oh My Zsh..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	}

	declare -A plugins=(
		# UX Enhancements
		[zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions
		[zsh-syntax-highlighting]=https://github.com/zsh-users/zsh-syntax-highlighting
		[zsh-history-substring-search]=https://github.com/zsh-users/zsh-history-substring-search
		[you-should-use]=https://github.com/MichaelAquilina/zsh-you-should-use
		[zsh-navigation-tools]=https://github.com/psprint/zsh-navigation-tools
		[zsh-autopair]=https://github.com/hlissner/zsh-autopair
		[fzf-tab]=https://github.com/Aloxaf/fzf-tab

		# Git
		[git-open]=https://github.com/paulirish/git-open
	)

	for name in "${!plugins[@]}"; do
		[[ -d "$ZSH_CUSTOM/plugins/$name" ]] || git clone "${plugins[$name]}" "$ZSH_CUSTOM/plugins/$name"
	done

	[[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
}

function install_starship() {
	header "Installing Starship..."
	curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_lazygit() {
	command -v lazygit &>/dev/null && {
		header "lazygit already installed"
		return
	}
	header "Installing lazygit..."
	local arch version url
	arch=$(uname -m)
	version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name":\s*"v\K[^"]+')

	case "$arch" in
	x86_64) url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" ;;
	aarch64 | armv7l) url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_arm64.tar.gz" ;;
	*)
		echo -e "${RED}Unsupported architecture: $arch${NC}"
		return 1
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

# -------------------------
# Setup Logic
# -------------------------
function setup_cli_tools() {
	header "Installing CLI packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}"
	install_ohmyzsh
	install_starship
	install_tpm
	install_lazygit
	chsh -s "$(which zsh)"
	sudo chsh -s "$(which zsh)" root
	sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
}

function setup_desktop_env() {
	header "Installing Desktop packages..."
	sudo apt update -y && sudo apt install -y "${CLI_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}"
	sudo pip3 install pywal --break-system
	mkdir -p "$FONT_DIR"
	cp -rv "$CURRENT_DIR/fonts/"* "$FONT_DIR"
	mkdir -p "$HOME/Pictures/Wallpapers"
	cp -rv "$CURRENT_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers"
	wal -nqi "$HOME/Pictures/Wallpapers/archkali.png"
	sudo mkdir -p "$XORG_DIR"
	sudo cp -rv "$CURRENT_DIR/xorg/"* "$XORG_DIR"
	sudo timedatectl set-timezone America/El_Salvador
}

function apply_dotfiles() {
	header "Applying dotfiles to user and root..."
	mkdir -p "$CONFIG_DIR"
	ln -sfv "$CURRENT_DIR/config/"* "$CONFIG_DIR/"
	ln -sfv "$CURRENT_DIR/.zshrc" "$HOME/.zshrc"
	ln -sfv "$CURRENT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
	ln -sfv "$CURRENT_DIR/.bashrc" "$HOME/.bashrc"

	sudo mkdir -p /root/.config
	sudo cp -rf "$CONFIG_DIR/"* /root/.config/
	sudo cp -f "$CURRENT_DIR/.zshrc" /root/.zshrc
	sudo cp -f "$CURRENT_DIR/.p10k.zsh" /root/.p10k.zsh
	sudo cp -f "$CURRENT_DIR/.bashrc" /root/.bashrc
}

# -------------------------
# Main Commands
# -------------------------
function cmd_setup_all() {
	[[ "$USER" == "root" ]] && {
		banner
		echo -e "${RED}Do not run this as root!${NC}"
		exit 1
	}
	banner
	require_cmd git
	require_cmd curl
	setup_cli_tools
	setup_desktop_env
	apply_dotfiles
	echo -e "${GREEN}✔ Environment configured successfully.${NC}"
	read -rp $'\e[1;33mDo you want to reboot now? ([y]/n): \e[0m' reply
	[[ "${reply:-y}" =~ ^[Yy]$ ]] && sudo reboot
}

# -------------------------
# Main
# -------------------------
COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
all) cmd_setup_all ;;
cli) setup_cli_tools ;;
desktop) setup_desktop_env ;;
dotfiles) apply_dotfiles ;;
help | *) usage ;;
esac
