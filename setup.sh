#!/bin/bash

# Author: Douglas Cabrera (aka @cabrera-evil)

# Colours
GREEN="\e[0;32m\033[1m"
NC="\033[0m\e[0m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
PURPLE="\e[0;35m\033[1m"
TURQUOISE="\e[0;36m\033[1m"
GRAY="\e[0;37m\033[1m"

# Global variables
dir=$(pwd)
fdir="$HOME/.local/share/fonts"
user=$(whoami)

# Function to exit the script
function ctrl_c() {
	echo -e "\n\n${RED}[!] Exiting..."
	exit 1
}

# Error handling function
function handle_error() {
	local exit_code=$1
	local command="${BASH_COMMAND}"

	if [ $exit_code -ne 0 ]; then
		echo -e "\n${RED}[-] Error: Command \"${command}\" failed with exit code ${exit_code}\n${NC}"
		exit 1
	fi
}

# Function to print header with the script name
function header() {
	echo -e "\n\n${BLUE}[*] $1${NC}\n"
	sleep 0.5
}

# Trap events
trap ctrl_c INT
trap 'handle_error $?' ERR

function banner() {
	echo -e "\n${TURQUOISE}              _____            ______"
	sleep 0.05
	echo -e "______ ____  ___  /______      ___  /___________________      ________ ___"
	sleep 0.05
	echo -e "_  __ \`/  / / /  __/  __ \     __  __ \_  ___/__  __ \_ | /| / /_  __ \`__ \\"
	sleep 0.05
	echo -e "/ /_/ // /_/ // /_ / /_/ /     _  /_/ /(__  )__  /_/ /_ |/ |/ /_  / / / / /"
	sleep 0.05
	echo -e "\__,_/ \__,_/ \__/ \____/      /_.___//____/ _  .___/____/|__/ /_/ /_/ /_/    ${NC}${YELLOW}(${NC}${GRAY}By ${NC}${PURPLE}@cabrera-evil${NC}${YELLOW})${NC}${TURQUOISE}"
	sleep 0.05
	echo -e "                                             /_/${NC}"
}

if [ "$user" == "root" ]; then
	banner
	echo -e "\n\n${RED}[!] You should not run the script as the root user!\n${NC}"
	exit 1
else
	banner
	header "[*] Installing necessary packages for the environment..."
	sudo apt install -y kitty rofi feh xclip ranger i3lock-fancy scrot scrub wmname firejail imagemagick cmatrix htop neofetch python3-pip procps tty-clock fzf lsd bat pamixer flameshot playerctl brightnessctl blueman bluez

	header "[*] Installing pywal..."
	sudo pip3 install pywal --break-system

	header "[*] Starting installation of necessary dependencies for the environment..."

	header "[*] Installing necessary dependencies for bspwm..."
	sudo apt install -y build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libuv1-dev

	header "[*] Installing necessary dependencies for polybar..."
	sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

	header "[*] Installing necessary dependencies for picom..."
	sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

	header "[*] Starting installation of the tools..."
	mkdir ~/tools && cd ~/tools

	header "[*] Installing bspwm..."
	git clone https://github.com/baskerville/bspwm.git
	cd bspwm
	make -j$(nproc)
	sudo make install
	cd ..

	header "[*] Installing sxhkd..."
	git clone https://github.com/baskerville/sxhkd.git
	cd sxhkd
	make -j$(nproc)
	sudo make install
	cd ..

	header "[*] Installing polybar..."
	git clone --recursive https://github.com/polybar/polybar
	cd polybar
	mkdir build
	cd build
	cmake ..
	make -j$(nproc)
	sudo make install
	cd ../../

	header "[*] Installing picom..."
	git clone https://github.com/ibhagwan/picom.git
	cd picom
	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build
	sudo ninja -C build install
	cd ..

	header "[*] Installing Oh My Zsh and Powerlevel10k for user $user..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

	header "[*] Installing Oh My Zsh and Powerlevel10k for user root..."
	sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k

	header "[*] Installing zsh-autosuggestions for user $user..."
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	header "[*] Installing zsh-autosuggestions for user root..."
	sudo git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	header "[*] Installing zsh-syntax-highlighting for user $user..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	header "[*] Installing zsh-syntax-highlighting for user root..."
	sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

	header "[*] Configuring touchpad..."
	sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee /etc/X11/xorg.conf.d/90-touchpad.conf <<'EOF' 1>/dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lrm"
        Option "NaturalScrolling" "on"
        Option "ScrollMethod" "twofinger"
EndSection
EOF

	header "[*] Configuring fonts..."
	if [[ -d "$fdir" ]]; then
		cp -rv $dir/fonts/* $fdir
	else
		mkdir -p $fdir
		cp -rv $dir/fonts/* $fdir
	fi

	header "[*] Configuring wallpaper..."
	if [[ -d "~/Pictures/Wallpapers" ]]; then
		cp -rv $dir/wallpapers/* ~/Pictures/Wallpapers
	else
		mkdir ~/Pictures/Wallpapers
		cp -rv $dir/wallpapers/* ~/Pictures/Wallpapers
	fi
	wal -nqi ~/Pictures/Wallpapers/archkali.png
	sudo wal -nqi ~/Pictures/Wallpapers/archkali.png

	header "[*] Configuring configuration files..."
	ln -s $dir/config/* ~/.config/

	header "[*] Configuring the .zshrc and .p10k.zsh files..."
	cp -v $dir/.zshrc ~/.zshrc
	sudo ln -sfv ~/.zshrc /root/.zshrc
	cp -v $dir/.p10k.zsh ~/.p10k.zsh
	sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh

	header "[*] Configuring scripts..."
	sudo cp -v $dir/scripts/whichSystem.py /usr/local/bin/
	touch ~/.config/polybar/scripts/target

	header "[*] Configuring necessary permissions and symbolic links..."
	sudo chmod +x /usr/local/bin/whichSystem.py
	sudo chmod +x /usr/local/bin/screenshot
	sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
	sudo chown root:root /usr/local/share/zsh/site-functions/_bspc
	sudo mkdir -p /root/.config/polybar/scripts/
	sudo touch /root/.config/polybar/scripts/target
	sudo ln -sfv ~/.config/polybar/scripts/target /root/.config/polybar/scripts/target
	cd ..

	header "[*] Removing tools directory..."
	rm -rfv ~/tools

	header "\n${GREEN}[+] Environment configured :D\n${NC}"

	while true; do
		echo -en "\n${YELLOW}[?] It's necessary to restart the system. Do you want to restart the system now? ([y]/n) ${NC}"
		read -r
		REPLY=${REPLY:-"y"}
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "\n\n${GREEN}[+] Restarting the system...\n${endColor}"
			sudo reboot
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			exit 0
		else
			echo -e "\n${RED}[!] Invalid response, please try again\n${NC}"
		fi
	done
fi
