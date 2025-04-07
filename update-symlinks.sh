#!/bin/bash

# Author: Douglas Cabrera (aka @cabrera-evil)

# Colors for terminal output
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
YELLOW='\e[1;33m'
PURPLE="\e[0;35m"
TURQUOISE="\e[0;36m"
GRAY="\e[0;37m"
NC='\e[0m' # No Color

# Global variables
current_dir=$(pwd)
config_dir="$HOME/.config"
user=$(whoami)

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
    echo -e "${YELLOW}Running as root, updating root symlinks...${NC}"
else
    banner
    echo -e "${YELLOW}Running as user, updating user symlinks...${NC}"
fi

header "Updating dotfiles symlinks..."
mkdir -p "$config_dir"
ln -sfv $current_dir/config/* $config_dir/

header "Creating symlinks for .zshrc, .p10k.zsh, and .bashrc..."
ln -sfv $current_dir/.zshrc $HOME/.zshrc
ln -sfv $current_dir/.p10k.zsh $HOME/.p10k.zsh
ln -sfv $current_dir/.bashrc $HOME/.bashrc

# Update symlinks for root user too if running as non-root user
header "Updating symlinks for root user..."
sudo ln -sfv $HOME/.zshrc /root/.zshrc
sudo ln -sfv $HOME/.p10k.zsh /root/.p10k.zsh
sudo ln -sfv $HOME/.bashrc /root/.bashrc

header "${GREEN}Symlinks updated successfully!${NC}"
