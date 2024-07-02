#!/bin/bash

# Update system
sudo pacman -Suy

# Define the path to the installer scripts
installer_dir="$(dirname "$(readlink -f "$0")")/installer"

# Run installation scripts
"$installer_dir/install_yay.sh"

# Update system
yay -Suy

"$installer_dir/install_ohmyzsh.sh"
"$installer_dir/install_packages.sh"
"$installer_dir/install_dotfiles.sh"

echo "All setup tasks completed."
