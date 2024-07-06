#!/bin/bash

# Directories
confpath="$HOME/.config"
backup_dir="$HOME/backup_configs"
script_root=$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")

# Create a backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Create a timestamp for the backup
timestamp=$(date +"%Y%m%d_%H%M%S")

# Determine the current machine
current_machine=$(hostname)

# Configuration files and directories to be backed up and linked
common_config_items=(
    "kitty"
    "waybar"
    "gtk-3.0"
    "qt6ct"
    "dolphinrc"
    "kdeglobals"
    "zshrc"
    "dunst"
    "MangoHud"
    "p10k.zsh"
)

# Function to check if any configuration directories exist
any_configs_exist() {
    for item in "${common_config_items[@]}"; do
        # Check if the item exists in script_root or confpath
        if [ -e "$script_root/$item" ] || [ -e "$confpath/$item" ] || [ -e "$HOME/.$item" ]; then
            return 0
        fi
        done

    # Check for specific hypr directory based on machine
    if [ "$current_machine" == "unArch" ] && [ -d "$script_root/hypr/pc" ]; then
        return 0
    elif [ "$current_machine" == "unArchLaptop" ] && [ -d "$script_root/hypr/laptop" ]; then
        return 0
    fi

    return 1
}

# Backup configuration directories from script_root
if any_configs_exist; then
    echo "Backing up existing configuration files..."
    # Backup only the items that are actually present in script_root
    items_to_backup=()
    for item in "${common_config_items[@]}"; do
        if [ -e "$script_root/$item" ]; then
            items_to_backup+=("$item")
        fi
    done

    # Add hypr directory to the backup if it exists
    if [ -d "$script_root/hypr" ]; then
        items_to_backup+=("hypr")
    fi

    # Backup files from script_root
    if [ ${#items_to_backup[@]} -gt 0 ]; then
        tar -czf "$backup_dir/config_backup_$timestamp.tar.gz" -C "$script_root" "${items_to_backup[@]}"
    else
        echo "No configuration files to back up."
    fi
else
    echo "No existing configuration files to back up."
fi

# Test output
echo "Configuration path: $confpath"
echo "Script root directory: $script_root"
echo "Current machine: $current_machine"

# Function to remove current configs
remove_configs() {
    echo "Removing current configuration files..."
    for item in "${common_config_items[@]}"; do
        if [ "$item" == "zshrc" ] || [ "$item" == "p10k.zsh" ]; then
            # Remove from home directory
            if [ -e "$HOME/.$item" ]; then
                rm -rf "$HOME/.$item"
            fi
        else
            # Remove from config directory
            if [ -e "$confpath/$item" ]; then
                rm -rf "$confpath/$item"
            fi
        fi
    done

    # Remove hypr directory if it exists
    if [ -d "$confpath/hypr" ]; then
        rm -rf "$confpath/hypr"
    fi
}

# Function to create symbolic links to new configs
create_symlinks() {
    echo "Creating symbolic links to new configuration files..."
    for item in "${common_config_items[@]}"; do
        if [ "$item" == "zshrc" ] || [ "$item" == "p10k.zsh" ]; then
            ln -sf "$script_root/$item" "$HOME/.$item"
        else
            ln -sf "$script_root/$item" "$confpath/$item"
        fi
    done

    # Create symbolic link for hypr configuration based on machine
    if [ "$current_machine" == "unArch" ]; then
        if [ -d "$script_root/hypr/pc" ]; then
            ln -sf "$script_root/hypr/pc" "$confpath/hypr"
        else
            echo "Hypr directory for 'unArch' does not exist."
        fi
    elif [ "$current_machine" == "unArchLaptop" ]; then
        if [ -d "$script_root/hypr/laptop" ]; then
            ln -sf "$script_root/hypr/laptop" "$confpath/hypr"
        else
            echo "Hypr directory for 'unArchLaptop' does not exist."
        fi
    else
        echo "Unknown machine type: $current_machine"
    fi
}

# Remove current configs
remove_configs

# Create symbolic links to new configs
create_symlinks

echo "Configuration files have been updated."

