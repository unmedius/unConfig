#!/bin/bash

# Define the expected directory
EXPECTED_DIR="$HOME/.unconfig"

# Check if the script is running from the expected directory
if [ "$(pwd)" != "$EXPECTED_DIR" ]; then
    echo "Error: This script must be run from the directory $EXPECTED_DIR"
    exit 1
fi

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./install.sh [laptop | desktop]"
    exit 1
fi

# Config

DEVICE_TYPE=$1

# Copy base configurations
cp -rf cachy/base/* ~/.config/

if  [! -d "~/.config/paper"]
    cp -rf paper ~/.config/
else
    echo "Wallpapers are already installed"
fi

# Apply specific configuration based on device type
if [ "$DEVICE_TYPE" == "laptop" ]; then
    cp -rf cachy/laptop/* ~/.config/
elif [ "$DEVICE_TYPE" == "desktop" ]; then
    cp -rf cachy/desktop/* ~/.config/
else
    echo "Unknown device type: $DEVICE_TYPE. Usage: ./install.sh [laptop | desktop]"
    exit 1
fi

echo "Configuration applied for $DEVICE_TYPE."

# Install necessary packages
# Check if packages are already installed

packages=(
    gnome-disk-utility firefox kitty telegram-desktop zoxide hypridle hyprlock yazi docker docker-compose distrobox neovim realtime-privileges nautilus virt-manager qemu qbittorrent freerdp netcat flatpak blueman mangohud goverlay
)

for package in "${packages[@]}"; do
    if ! pacman -Qq | grep -q "^$package\$"; then
        echo "Installing $package..."
        echo "----------------------"
        sudo pacman -S --noconfirm "$package"
        echo "----------------------"
    else
        echo "$package is already installed"
    fi
done

# Check if paru packages are installed
paru_packages=(
  game-devices-udev
)

for paru_package in "${paru_packages[@]}"; do
    if ! paru -Qq | grep -q "^$paru_package\$"; then
        echo "Installing $paru_package..."
        echo "----------------------"
        paru -S --noconfirm "$paru_package"
        echo "----------------------"
    else
        echo "$paru_package is already installed"
    fi
done

# Disable UFW (note: this may affect system security)
sudo ufw disable

# Clone and set up configurations

# Install NvChad for Neovim
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/NvChad/starter ~/.config/nvim
else
    echo "NvChad is already installed"
fi

# Install Rofi theme collection
if [ ! -d "~/.local/share/rofi/themes" ]; then
    git clone https://github.com/lr-tech/rofi-themes-collection.git
    mkdir -p ~/.local/share/rofi/themes
    cp rofi-themes-collection/themes/* ~/.local/share/rofi/themes
    rm -rf rofi-themes-collection
else
    echo "Rofi themes are already installed"
fi

# Add user to groups
sudo usermod -aG realtime $USER
sudo usermod -aG docker $USER
sudo usermod -aG libvirt $USER

# Enable required services
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now docker.service

# Git configuration
git config --global credential.helper store
git config --global user.name "$USER"
git config --global user.email "$USER@gmail.com"

echo "Installation and configuration completed successfully!"

