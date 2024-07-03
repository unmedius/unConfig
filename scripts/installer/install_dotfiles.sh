#!/bin/bash

# Directories
confpath="$HOME/.config"
backup_dir="$HOME/backup_configs"
script_root=$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")

# Create a backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Create a timestamp for the backup
timestamp=$(date +"%Y%m%d_%H%M%S")

# Configuration files and directories to be backed up and linked
config_items=(
    "hypr"
    "kitty"
    "waybar"
    "gtk-3.0"
    "qt6ct"
    "dolphinrc"
    "kdeglobals"
    "zshrc"
    "dunst"
)

# Function to check if any configuration directories exist
any_configs_exist() {
    for item in "${config_items[@]}"; do
        if [ -e "$script_root/$item" ]; then
            return 0
        fi
    done
    return 1
}

# Backup configuration directories
if any_configs_exist; then
    echo "Backing up existing configuration files..."
    tar -czf "$backup_dir/config_backup_$timestamp.tar.gz" -C "$script_root" "${config_items[@]}"
else
    echo "No existing configuration files to back up."
fi

# Test output
echo "Configuration path: $confpath"
echo "Script root directory: $script_root"

# Function to remove current configs
remove_configs() {
    echo "Removing current configuration files..."
    for item in "${config_items[@]}"; do
        if [ "$item" == "zshrc" ]; then
            rm -rf "$HOME/.$item"
        else
            rm -rf "$confpath/$item"
        fi
    done
}

# Function to create symbolic links to new configs
create_symlinks() {
    echo "Creating symbolic links to new configuration files..."
    for item in "${config_items[@]}"; do
        if [ "$item" == "zshrc" ]; then
            ln -s "$script_root/$item" "$HOME/.$item"
        else
            ln -s "$script_root/$item" "$confpath/$item"
        fi
    done
}

# Remove current configs
remove_configs

# Create symbolic links to new configs
create_symlinks

echo "Configuration files have been updated."
