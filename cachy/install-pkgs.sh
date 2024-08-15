#!/bin/bash

sudo pacman -S gnome-disk-utility firefox kitty telegram-desktop zoxide hypridle hyprlock yazi docker docker-compose distrobox neovim realtime-privileges nautilus virt-manager qemu qbittorrent freerdp netcat flatpak blueman mangohud goverlay

paru -S game-devices-udev

sudo ufw disable

git clone https://github.com/NvChad/starter ~/.config/nvim

git clone https://github.com/lr-tech/rofi-themes-collection.git
mkdir -p ~/.local/share/rofi/themes
cp rofi-themes-collection/themes/* ~/.local/share/rofi/themes
rm -rf rofi-themes-collection

sudo usermod -aG realtime $USER
sudo usermod -aG docker $USER
sudo usermod -aG libvirt $USER

sudo systemctl enable libvirtd.service libvirtd.socket
sudo systemctl enable bluetooth.service
sudo systemctl enable docker.service

git config --global credential.helper store
git config --global user.name $USER
git config --global user.email $USER@gmail.com
