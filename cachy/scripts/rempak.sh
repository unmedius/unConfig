#!/bin/bash

# Check if an argument (package name) was passed
if [ $# -eq 0 ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

PACKAGE_NAME=$1
found=0
available_managers=()

# Function to search for a package in system packages (pacman/paru)
search_in_system() {
    if pacman -Qi "$PACKAGE_NAME" &> /dev/null; then
        available_managers+=("system package (pacman/paru)")
        echo "Found '$PACKAGE_NAME' as a system package."
        return 0
    fi
    return 1
}

# Function to search for a package in flatpak
search_in_flatpak() {
    if flatpak list | grep -q "$PACKAGE_NAME"; then
        available_managers+=("flatpak")
        echo "Found '$PACKAGE_NAME' in flatpak."
        return 0
    fi
    return 1
}

# Function to remove a package using system package manager
remove_with_system() {
    echo "Removing '$PACKAGE_NAME' using system package manager..."
    sudo pacman -R --noconfirm "$PACKAGE_NAME"
}

# Function to remove a package using flatpak
remove_with_flatpak() {
    echo "Removing '$PACKAGE_NAME' using flatpak..."
    flatpak uninstall --delete-data --assumeyes "$PACKAGE_NAME"
}

# Search for the package in different package managers
echo "Searching for '$PACKAGE_NAME'..."

search_in_system
search_in_flatpak

# Check if the package was found in any manager
if [ ${#available_managers[@]} -eq 0 ]; then
    echo "Package '$PACKAGE_NAME' not found in any package manager."
    exit 1
fi

# Prompt user for removal choice
echo "You can remove '$PACKAGE_NAME' using the following package managers:"
for i in "${!available_managers[@]}"; do
    echo "$((i + 1)). ${available_managers[i]}"
done
echo "$(( ${#available_managers[@]} + 1 )). Exit"

read -p "Enter your choice (1-$(( ${#available_managers[@]} + 1 ))): " choice

if [[ "$choice" -ge 1 && "$choice" -le "${#available_managers[@]}" ]]; then
    case ${available_managers[$((choice - 1))]} in
        "system package (pacman/paru)")
            remove_with_system
            ;;
        "flatpak")
            remove_with_flatpak
            ;;
    esac
else
    echo "Invalid choice. Exiting."
    exit 1
fi

echo "Removal complete."

