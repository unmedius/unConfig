#!/bin/bash

sudo pacman -S gnome-disk-utility firefox kitty telegram-desktop zoxide hypridle hyprlock yazi docker docker-compose distrobox neovim realtime-privileges nautilus

sudo ufw allow ssh

git clone https://github.com/NvChad/starter ~/.config/nvim

git clone https://github.com/lr-tech/rofi-themes-collection.git
mkdir -p ~/.local/share/rofi/themes
cp rofi-themes-collection/themes/* ~/.local/share/rofi/themes
rm -rf rofi-themes-collection

sudo usermod -aG realtime $USER
sudo usermod -aG docker $USER

git config --global credential.helper store
git config --global user.name $USER
git config --global user.email $USER@gmail.com
