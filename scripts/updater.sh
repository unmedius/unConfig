#!/bin/bash

# Function to list updates for a given package manager
list_updates() {
    local pm="$1"
    local updates
    echo -n "Checking for updates using $pm... "
    case "$pm" in
        flatpak)
            updates=$(flatpak remote-ls --updates 2>&1)
            if [[ -z "$updates" ]]; then
                updates="Nothing to do."
            fi
            ;;
        yay)
            updates=$(yay -Qu 2>/dev/null)
            ;;
        *)
            echo "Unknown package manager: $pm"
            return 1
            ;;
    esac

    if [ -z "$updates" ] || [[ "$updates" == "Nothing to do." ]]; then
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
        flatpak) flatpak update -y ;;
        yay) yay -Syu --noconfirm ;;
        *) echo "Unknown package manager: $pm"; return 1 ;;
    esac
}

# Flag to track if there are any updates
any_updates=false

# List available updates and prompt user for confirmation
for pm in flatpak yay; do
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
if [[ "$choice" =~ ^[yY]$ ]]; then
    # Update Flatpak and Yay repositories
    for pm in flatpak yay; do
        if command -v $pm &> /dev/null; then
            update_packages "$pm"
        fi
    done
else
    echo "Update cancelled by user."
fi
