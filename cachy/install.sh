#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./install.sh [laptop | desktop]"
    exit 1
fi

# Config

DEVICE_TYPE=$1

# Copy base configurations
cp -rf base/* ~/.config/
cp -rf ../paper ~/.config/ 

# Apply specific configuration based on device type
if [ "$DEVICE_TYPE" == "laptop" ]; then
    cp -rf laptop/* ~/.config/
elif [ "$DEVICE_TYPE" == "desktop" ]; then
    cp -rf desktop/* ~/.config/
else
    echo "Unknown device type: $DEVICE_TYPE. Usage: ./install.sh [laptop | desktop]"
    exit 1
fi

echo "Configuration applied for $DEVICE_TYPE."

# Install necessary packages

sudo pacman -S --noconfirm gnome-disk-utility firefox kitty telegram-desktop zoxide hypridle hyprlock yazi docker docker-compose distrobox neovim realtime-privileges nautilus virt-manager qemu qbittorrent freerdp netcat flatpak blueman mangohud goverlay

paru -S --noconfirm game-devices-udev

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
git clone https://github.com/lr-tech/rofi-themes-collection.git
mkdir -p ~/.local/share/rofi/themes
cp rofi-themes-collection/themes/* ~/.local/share/rofi/themes
rm -rf rofi-themes-collection

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

