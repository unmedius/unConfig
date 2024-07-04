#!/bin/bash

# Function to list updates for a given package manager
list_updates() {
    local pm="$1"
    local updates
    echo -n "Checking for updates using $pm... "
    case "$pm" in
        pacman)
            updates=$(pacman -Qu)
            ;;
        flatpak)
            updates=$(flatpak update 2>&1)
            if [[ "$updates" == *"Nothing to do."* ]]; then
                updates=""
            fi
            ;;
        yay)
            updates=$(yay -Qu)
            ;;
        *)
            echo "Unknown package manager: $pm"
            exit 1
            ;;
    esac

    if [ -z "$updates" ]; then
        echo "No updates available."
    else
        echo "Updates available:"
        echo "$updates"
        any_updates=true
    fi
}

# Function to update packages using a given package manager
update_packages() {
    local pm="$1"
    echo "Updating packages using $pm..."
    case "$pm" in
        pacman) sudo pacman -Syu --noconfirm ;;
        flatpak) flatpak update ;;
        yay) yay -Suy --noconfirm ;;
        *) echo "Unknown package manager: $pm"; exit 1 ;;
    esac
}

# Flag to track if there are any updates
any_updates=false

# List available updates and prompt user for confirmation
for pm in pacman flatpak yay; do
    if command -v $pm &> /dev/null; then
        list_updates "$pm"
    else
        echo "Error: $pm not installed or not in PATH."
    fi
done

if ! $any_updates; then
    echo "No updates available for any package manager."
    exit 0
fi

read -p "Do you want to update all packages? (y/n) " choice
if [[ "$choice" == [yY] ]]; then
    # Update Pacman and Flatpak repositories
    for pm in pacman flatpak; do
        update_packages "$pm"
    done

    # Check for yay and update AUR packages if available
    if command -v yay &> /dev/null; then
        echo "Updating AUR packages using yay..."
        update_packages "yay"
    else
        echo "Error: yay not installed. Install it first: 'yay -S aur/yay'"
    fi
else
    echo "Update cancelled by user."
fi
