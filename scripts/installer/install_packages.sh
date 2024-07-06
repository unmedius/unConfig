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
)

declare -A machine_specific_config_items=(
    [unArch]="specific_config1 specific_config2"
    [unArchLaptop]="specific_config3 specific_config4"
)

# Function to check if any configuration directories exist
any_configs_exist() {
    for item in "${common_config_items[@]}" "${machine_specific_config_items[$current_machine]}"; do
        if [ -e "$script_root/$item" ]; then
            return 0
        fi
    done
    return 1
}

# Backup configuration directories
if any_configs_exist; then
    echo "Backing up existing configuration files..."
    tar -czf "$backup_dir/config_backup_$timestamp.tar.gz" -C "$script_root" "${common_config_items[@]}" "${machine_specific_config_items[$current_machine]}"
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
    for item in "${common_config_items[@]}" "${machine_specific_config_items[$current_machine]}"; do
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
    for item in "${common_config_items[@]}" "${machine_specific_config_items[$current_machine]}"; do
        if [ "$item" == "zshrc" ]; then
            ln -s "$script_root/$item" "$HOME/.$item"
        else
            ln -s "$script_root/$item" "$confpath/$item"
        fi
    done

    # Create symbolic link for hypr configuration
    if [ "$current_machine" == "unArch" ]; then
        ln -s "$script_root/hypr/pc" "$confpath/hypr"
    elif [ "$current_machine" == "unArchLaptop" ]; then
        ln -s "$script_root/hypr/laptop" "$confpath/hypr"
    else
        echo "Unknown machine type: $current_machine"
    fi
}

# Function to update and install packages with pacman
update_and_install_pacman_packages() {
    local packages=("$@")
    echo "Updating system with pacman..."
    sudo pacman -Syu --noconfirm

    echo "Checking and installing necessary packages with pacman..."
    for package in "${packages[@]}"; do
        if ! pacman -Qi "$package" &> /dev/null; then
            echo "Installing $package..."
            sudo pacman -S "$package" --noconfirm
        else
            echo "$package is already installed."
        fi
    done
}

# Function to update and install packages with yay
update_and_install_yay_packages() {
    local packages=("$@")
    echo "Updating system with yay..."
    yay -Syu --noconfirm

    echo "Checking and installing necessary packages with yay..."
    for package in "${packages[@]}"; do
        if ! yay -Qi "$package" &> /dev/null; then
            echo "Installing $package..."
            yay -S "$package" --noconfirm
        else
            echo "$package is already installed."
        fi
    done
}

# Separate common and machine-specific packages
common_pacman_packages=("${common_config_items[@]}")
common_yay_packages=()
machine_pacman_packages=("${machine_specific_config_items[$current_machine]}")
machine_yay_packages=()

# Collect pacman and yay packages
all_pacman_packages=("${common_pacman_packages[@]}" "${machine_pacman_packages[@]}")
all_yay_packages=("${common_yay_packages[@]}" "${machine_yay_packages[@]}")

# Remove current configs
remove_configs

# Create symbolic links to new configs
create_symlinks

# Update and install packages with pacman
update_and_install_pacman_packages "${all_pacman_packages[@]}"

# Ensure 'yay' is installed for AUR packages
if ! command -v yay &> /dev/null; then
    echo "Installing 'yay' AUR helper..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

# Update and install packages with yay
update_and_install_yay_packages "${all_yay_packages[@]}"

echo "Configuration files and packages have been updated."
