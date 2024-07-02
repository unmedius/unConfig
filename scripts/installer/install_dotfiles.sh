#!/bin/bash

# Directories
confpath="$HOME/.config"
backup_dir="$HOME/backup_configs"
script_root=$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")

# Create a backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Create a timestamp for the backup
timestamp=$(date +"%Y%m%d_%H%M%S")

# Backup configuration directories
if [ -d "$script_root/hypr" ] || [ -d "$script_root/kitty" ] || [ -d "$script_root/waybar" ] || [ -d "$script_root/gtk-3.0"] || [ -d "$script_root/qt6ct"] || [ -d "$script_root/dolphinrc"] || [ -d "$script_root/kdeglobals"] || [ -d "$script_root/zshrc"] || [ - "$script_root/dunst"]; then
    echo "Backing up existing configuration files..."
    tar -czf "$backup_dir/config_backup_$timestamp.tar.gz" -C "$script_root" hypr kitty waybar gtk-3.0 qt6ct dolphinrc kdeglobals zshrc dunst
else
    echo "No existing configuration files to back up."
fi


# Test output
echo "Configuration path: $confpath"
echo "Script root directory: $script_root"

# Remove current configs
echo "Removing current configuration files..."
rm -rf "$confpath/hypr" "$confpath/kitty" "$confpath/waybar" "$confpath/gtk-3.0" 
rm -rf "$confpath/qt6ct" "$confpath/dolphinrc" "$confpath/kdeglobals" "$HOME/.zshrc" 
rm -rf "$confpath/dunst"

# Create symbolic links to new configs
echo "Creating symbolic links to new configuration files..."
ln -s "$script_root/hypr" "$confpath/hypr"
ln -s "$script_root/kitty" "$confpath/kitty"
ln -s "$script_root/waybar" "$confpath/waybar"
ln -s "$script_root/gtk-3.0" "$confpath/gtk-3.0"
ln -s "$script_root/qt6ct" "$confpath/qt6ct"
ln -s "$script_root/dunst" "$confpath/dunst"
ln -s "$script_root/dolphinrc" "$confpath/dolphinrc"
ln -s "$script_root/kdeglobals" "$confpath/kdeglobals"
ln -s "$script_root/zshrc" "$HOME/.zshrc"

