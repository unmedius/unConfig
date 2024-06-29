#!/bin/bash

# directories
confpath=$HOME/.config
curdir=$(dirname "$(dirname "$0")")
cur=$(basename $curdir)

sudo pacman -S hyprpaper waybar polkit polkit-kde-agent zsh btop neovim turbostat firefox qpwgraph flatpak ttf-font-awesome pamixer qbittorrent

#test
echo $confpath
echo $cur

# remove current configs
rm -rf $confpath/hypr $confpath/kitty $confpath/waybar

# links to conf
ln -s $HOME/$cur/hypr $confpath
ln -s $HOME/$cur/kitty $confpath
ln -s $HOME/$cur/waybar $confpath

# echo "The script you are running has:"
# echo "basename: [$(basename "$0")]"
# echo "dirname : [$(dirname "$0")]"
# echo "parent  : [$(dirname "$(dirname "$0")")]"
# echo "pwd     : [$(pwd)]"