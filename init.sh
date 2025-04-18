#!/bin/bash

# Author: Douglas Cabrera (aka @cabrera-evil)

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
PURPLE="\e[0;35m"
TURQUOISE="\e[0;36m"
GRAY="\e[0;37m"
NC='\e[0m' # No Color

# Global variables
current_dir=$(pwd)
font_dir="$HOME/.local/share/fonts"
xorg_dir="/etc/X11/xorg.conf.d"
user=$(whoami)
packages=(
	bat
	blueman
	bluez
	brightnessctl
	bspwm
	cmatrix
	dunst
	exo-utils
	feh
	flameshot
	firejail
	fzf
	htop
	i3lock-fancy
	imagemagick
	kitty
	lxappearance
	lsd
	neofetch
	numlockx
	numix-icon-theme
	numix-icon-theme-circle
	pamixer
	polybar
	picom
	playerctl
	python3-pip
	ranger
	rofi
	rsync
	scrub
	sxhkd
	tmux
	tty-clock
	wmname
	xclip
)

# Function to exit the script
function ctrl_c() {
	echo -e "${RED}Exiting...${NC}"
	exit 1
}

# Error handling function
function handle_error() {
	local exit_code=$1
	local command="${BASH_COMMAND}"

	if [ $exit_code -ne 0 ]; then
		echo -e "${RED}Error: Command \"${command}\" failed with exit code ${exit_code}${NC}"
		exit 1
	fi
}

# Function to print header with the script name
function header() {
	echo -e "${BLUE}$1${NC}"
	sleep 1
}

# Trap events
trap ctrl_c INT
trap 'handle_error $?' ERR

function banner() {
	echo -e "${TURQUOISE}              _____            ______"
	echo -e "______ ____  ___  /______      ___  /___________________      ________ ___"
	echo -e "_  __ \`/  / / /  __/  __ \     __  __ \_  ___/__  __ \_ | /| / /_  __ \`__ \\"
	echo -e "/ /_/ // /_/ // /_ / /_/ /     _  /_/ /(__  )__  /_/ /_ |/ |/ /_  / / / / /"
	echo -e "\__,_/ \__,_/ \__/ \____/      /_.___//____/ _  .___/____/|__/ /_/ /_/ /_/    ${NC}${YELLOW}(${NC}${GRAY}By ${NC}${PURPLE}@cabrera-evil${NC}${YELLOW})${NC}${TURQUOISE}"
	echo -e "                                             /_/${NC}"
}

if [ "$user" == "root" ]; then
	banner
	echo -e "${RED}You should not run the script as the root user!${NC}"
	exit 1
else
	banner
	header "Installing necessary packages for the environment..."
	sudo apt update -y && sudo apt install -y "${packages[@]}"

	header "Installing pywal..."
	sudo pip3 install pywal --break-system

	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		header "Installing Oh My Zsh for user $USER..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	else
		header "Oh My Zsh is already installed for user $USER."
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
		header "Installing Powerlevel10k theme for user $USER..."
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	else
		header "Powerlevel10k is already installed for user $USER."
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
		header "Installing zsh-autosuggestions for user $USER..."
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	else
		header "zsh-autosuggestions is already installed for user $USER."
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
		header "Installing zsh-syntax-highlighting for user $USER..."
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	else
		header "zsh-syntax-highlighting is already installed for user $USER."
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/you-should-use" ]; then
		header "Installing you-should-use for user $USER..."
		git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use
	else
		header "you-should-use is already installed for user $USER."
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search" ]; then
		header "Installing zsh-history-substring-search for user $USER..."
		git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
	else
		header "zsh-history-substring-search is already installed for user $USER."
	fi

	if [ ! -d "/root/.oh-my-zsh" ]; then
		header "Copying Oh My Zsh configuration to user root..."
		sudo cp -r $HOME/.oh-my-zsh /root/
	else
		header "Oh My Zsh is already installed for user root."
	fi

  if [! -d "$HOME/.tmux/plugins/tpm" ]; then
    header "Installing Tmux Plugin Manager for user $USER..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else 
    header "Tmux Plugin Manager is already installed for user $USER."
  fi

  header "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  wget -O /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit -D -t /usr/local/bin/

	header "Configuring terminal emulator..."
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50
	sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty

	header "Configuring xorg..."
	sudo mkdir -p $xorg_dir
	sudo cp -rv $current_dir/xorg/* $xorg_dir

	header "Configuring fonts..."
	mkdir -p $font_dir
	cp -rv $current_dir/fonts/* $font_dir

	header "Configuring wallpaper..."
	if [[ -d "$HOME/Pictures/Wallpapers" ]]; then
		cp -rv $current_dir/wallpapers/* $HOME/Pictures/Wallpapers
	else
		mkdir $HOME/Pictures/Wallpapers
		cp -rv $current_dir/wallpapers/* $HOME/Pictures/Wallpapers
	fi
	wal -nqi $HOME/Pictures/Wallpapers/archkali.png

	header "Configuring timezone..."
	sudo timedatectl set-timezone America/El_Salvador

	header "Configuring dotfiles symlinks..."
	mkdir -p "$HOME/.config"
	ln -sfv $current_dir/config/* $HOME/.config/

	header "Configuring zsh as default shell..."
	chsh -s $(which zsh)
	sudo chsh -s $(which zsh) root

	header "Configuring the .zshrc and .p10k.zsh files..."
	ln -sfv $current_dir/.zshrc $HOME/.zshrc
	ln -sfv $current_dir/.p10k.zsh $HOME/.p10k.zsh
	ln -sfv $current_dir/.bashrc $HOME/.bashrc
	sudo ln -sfv $HOME/.zshrc /root/.zshrc
	sudo ln -sfv $HOME/.p10k.zsh /root/.p10k.zsh
	sudo ln -sfv $HOME/.bashrc /root/.bashrc

	header "${GREEN}Environment configured :D${NC}"

	while true; do
		echo -en "${YELLOW}It's necessary to restart the system. Do you want to restart the system now? ([y]/n)${NC}"
		read -r
		REPLY=${REPLY:-"y"}
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "${GREEN}Restarting the system...${NC}"
			sudo reboot
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			exit 0
		else
			echo -e "${RED}Invalid response, please try again${NC}"
		fi
	done
fi
