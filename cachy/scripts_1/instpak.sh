#!/bin/bash

# Check if an argument (package name) was passed
if [ $# -eq 0 ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

PACKAGE_NAME=$1
available_managers=()

# Function to search for a package in pacman
search_in_pacman() {
    if pacman -Qi "$PACKAGE_NAME" &> /dev/null; then
        available_managers+=("pacman")
        echo "Found '$PACKAGE_NAME' in pacman."
        pacman -Qi "$PACKAGE_NAME"
        echo "*****************************"
        return 0
    elif pacman -Ss "$PACKAGE_NAME" | grep -q "$PACKAGE_NAME"; then
        available_managers+=("pacman")
        echo "Package not found, but the following options are available in pacman:"
        pacman -Ss "$PACKAGE_NAME" | grep "$PACKAGE_NAME"
        echo "*****************************"
        return 0
    fi
    return 1
}

# Function to search for a package in paru
search_in_paru() {
    if paru -Qi "$PACKAGE_NAME" &> /dev/null; then
        available_managers+=("paru")
        echo "Found '$PACKAGE_NAME' in paru."
        paru -Qi "$PACKAGE_NAME"
        echo "****************************"
        return 0
    elif paru -Ss "$PACKAGE_NAME" | grep -q "$PACKAGE_NAME"; then
        available_managers+=("paru")
        echo "Package not found, but the following options are available in paru:"
        paru -Ss "$PACKAGE_NAME" | grep "$PACKAGE_NAME"
        echo "****************************"
        return 0
    fi
    return 1
}

# Function to search for a package in flatpak
search_in_flatpak() {
    if flatpak search "$PACKAGE_NAME" | grep -q "$PACKAGE_NAME"; then
        available_managers+=("flatpak")
        echo "Found '$PACKAGE_NAME' in flatpak."
        flatpak search "$PACKAGE_NAME" | grep "$PACKAGE_NAME"
        echo "****************************"
        return 0
    fi
    return 1
}

# Function to install a package using pacman
install_with_pacman() {
    echo "Installing '$PACKAGE_NAME' via pacman..."
    sudo pacman -S --noconfirm "$PACKAGE_NAME"
}

# Function to install a package using paru
install_with_paru() {
    echo "Installing '$PACKAGE_NAME' via paru..."
    paru -S --noconfirm "$PACKAGE_NAME"
}

# Function to install a package using flatpak
install_with_flatpak() {
    echo "Installing '$PACKAGE_NAME' via flatpak..."
    flatpak install flathub "$PACKAGE_NAME" -y
}

# Search for the package in various package managers
echo "Searching for '$PACKAGE_NAME'..."

search_in_pacman
search_in_paru
search_in_flatpak

# Check if the package was found in any manager
if [ ${#available_managers[@]} -eq 0 ]; then
    echo "Package '$PACKAGE_NAME' not found in any package manager."
    exit 1
fi

# Prompt user for installation choice
echo "You can install '$PACKAGE_NAME' from the following package managers:"
for i in "${!available_managers[@]}"; do
    echo "$((i + 1)). ${available_managers[i]}"
done
echo "$(( ${#available_managers[@]} + 1 )). Exit"

# Read user choice
read -p "Enter your choice (1-$(( ${#available_managers[@]} + 1 ))): " choice

# Process user choice
if [[ "$choice" -ge 1 && "$choice" -le "${#available_managers[@]}" ]]; then
    case ${available_managers[$((choice - 1))]} in
        "pacman")
            install_with_pacman
            ;;
        "paru")
            install_with_paru
            ;;
        "flatpak")
            install_with_flatpak
            ;;
    esac
else
    echo "Invalid choice. Exiting."
    exit 1
fi

echo "Installation complete."

