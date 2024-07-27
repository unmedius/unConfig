#!/bin/bash

# Function to run installer scripts
run_installers() {
    local installer_dir="$1"

    echo "Running installer scripts..."
    "$installer_dir/install_ohmyzsh.sh"
    "$installer_dir/install_packages.sh"
    "$installer_dir/install_dotfiles.sh"
}

# Main script execution
main() {
    # Define the path to the installer scripts
    local installer_dir="$(dirname "$(readlink -f "$0")")/installer"

    # Run installer scripts
    run_installers "$installer_dir"

    echo "All setup tasks completed."
}

# Execute main function
main
