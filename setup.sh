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

trap ctrl_c INT

function ctrl_c() {
	echo -e "\n\n${RED}[!] Exiting...\n${NC}"
	exit 1
}

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
	sleep 1
	echo -e "\n\n${BLUE}[*] Installing necessary packages for the environment...\n${NC}"
	sleep 2
	sudo apt install -y kitty rofi feh xclip ranger i3lock-fancy scrot scrub wmname firejail imagemagick cmatrix htop neofetch python3-pip procps tty-clock fzf lsd bat pamixer flameshot playerctl brightnessctl blueman bluez
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some packages!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${BLUE}[*] Installing pywal...\n${NC}"
	sleep 2
	sudo pip3 install pywal --break-system
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install pywal or operation cancelled by user!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${BLUE}[*] Starting installation of necessary dependencies for the environment...\n${NC}"
	sleep 0.5

	echo -e "\n${PURPLE}[*] Installing necessary dependencies for bspwm...\n${NC}"
	sleep 2
	sudo apt install -y build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libuv1-dev
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some dependencies for bspwm!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing necessary dependencies for polybar...\n${NC}"
	sleep 2
	sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some dependencies for polybar!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing necessary dependencies for picom...\n${NC}"
	sleep 2
	sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install some dependencies for picom!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${BLUE}[*] Starting installation of the tools...\n${NC}"
	sleep 0.5
	mkdir ~/tools && cd ~/tools

	echo -e "\n${PURPLE}[*] Installing bspwm...\n${NC}"
	sleep 2
	git clone https://github.com/baskerville/bspwm.git
	cd bspwm
	make -j$(nproc)
	sudo make install
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install bspwm!\n${NC}"
		exit 1
	else
		sudo apt install bspwm -y
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi
	cd ..

	echo -e "\n${PURPLE}[*] Installing sxhkd...\n${NC}"
	sleep 2
	git clone https://github.com/baskerville/sxhkd.git
	cd sxhkd
	make -j$(nproc)
	sudo make install
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install sxhkd!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	cd ..

	echo -e "\n${PURPLE}[*] Installing polybar...\n${NC}"
	sleep 2
	git clone --recursive https://github.com/polybar/polybar
	cd polybar
	mkdir build
	cd build
	cmake ..
	make -j$(nproc)
	sudo make install
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install polybar!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	cd ../../

	echo -e "\n${PURPLE}[*] Installing picom...\n${NC}"
	sleep 2
	git clone https://github.com/ibhagwan/picom.git
	cd picom
	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build
	sudo ninja -C build install
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install picom!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	cd ..

	echo -e "\n${PURPLE}[*] Installing Oh My Zsh and Powerlevel10k for user $user...\n${NC}"
	sleep 2
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install Oh My Zsh and Powerlevel10k for user $user!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing Oh My Zsh and Powerlevel10k for user root...\n${NC}"
	sleep 2
	sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install Oh My Zsh and Powerlevel10k for user root!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing zsh-autosuggestions for user $user...\n${NC}"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install zsh-autosuggestions for user $user!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing zsh-autosuggestions for user root...\n${NC}"
	sudo git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install zsh-autosuggestions for user root!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing zsh-syntax-highlighting for user $user...\n${NC}"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install zsh-syntax-highlighting for user $user!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${PURPLE}[*] Installing zsh-syntax-highlighting for user root...\n${NC}"
	sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${RED}[-] Failed to install zsh-syntax-highlighting for user root!\n${NC}"
		exit 1
	else
		echo -e "\n${GREEN}[+] Done\n${NC}"
		sleep 1.5
	fi

	echo -e "\n${BLUE}[*] Configuring touchpad...\n${NC}"
	sleep 2
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

	echo -e "\n${BLUE}[*] Starting configuration of fonts, wallpaper, configuration files, .zshrc, .p10k.zsh, and scripts...\n${NC}"
	sleep 0.5

	echo -e "\n${PURPLE}[*] Configuring fonts...\n${NC}"
	sleep 2
	if [[ -d "$fdir" ]]; then
		cp -rv $dir/fonts/* $fdir
	else
		mkdir -p $fdir
		cp -rv $dir/fonts/* $fdir
	fi
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring wallpaper...\n${NC}"
	sleep 2
	if [[ -d "~/Pictures/Wallpapers" ]]; then
		cp -rv $dir/wallpapers/* ~/Pictures/Wallpapers
	else
		mkdir ~/Pictures/Wallpapers
		cp -rv $dir/wallpapers/* ~/Pictures/Wallpapers
	fi
	wal -nqi ~/Pictures/Wallpapers/archkali.png
	sudo wal -nqi ~/Pictures/Wallpapers/archkali.png
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring configuration files...\n${NC}"
	sleep 2
	ln -s $dir/config/* ~/.config/
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring the .zshrc and .p10k.zsh files...\n${NC}"
	sleep 2
	cp -v $dir/.zshrc ~/.zshrc
	sudo ln -sfv ~/.zshrc /root/.zshrc
	cp -v $dir/.p10k.zsh ~/.p10k.zsh
	sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring scripts...\n${NC}"
	sleep 2
	sudo cp -v $dir/scripts/whichSystem.py /usr/local/bin/
	touch ~/.config/polybar/scripts/target
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Configuring necessary permissions and symbolic links...\n${NC}"
	sleep 2
	sudo chmod +x /usr/local/bin/whichSystem.py
	sudo chmod +x /usr/local/bin/screenshot
	sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
	sudo chown root:root /usr/local/share/zsh/site-functions/_bspc
	sudo mkdir -p /root/.config/polybar/scripts/
	sudo touch /root/.config/polybar/scripts/target
	sudo ln -sfv ~/.config/polybar/scripts/target /root/.config/polybar/scripts/target
	cd ..
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${PURPLE}[*] Removing tools directory...\n${NC}"
	sleep 2
	rm -rfv ~/tools
	echo -e "\n${GREEN}[+] Done\n${NC}"
	sleep 1.5

	echo -e "\n${GREEN}[+] Environment configured :D\n${NC}"
	sleep 1.5

	while true; do
		echo -en "\n${YELLOW}[?] It's necessary to restart the system. Do you want to restart the system now? ([y]/n) ${NC}"
		read -r
		REPLY=${REPLY:-"y"}
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "\n\n${GREEN}[+] Restarting the system...\n${endColor}"
			sleep 1
			sudo reboot
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			exit 0
		else
			echo -e "\n${RED}[!] Invalid response, please try again\n${NC}"
		fi
	done
fi
