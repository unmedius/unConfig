#!/bin/bash

# Define common packages
common_packages=(
    hyprland wofi kitty dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland grim slurp
    polkit polkit-kde-agent sddm hyprpaper waybar zsh neovim flatpak ttf-font-awesome pamixer
    qbittorrent pavucontrol btop qpwgraph htop vlc brightnessctl unzip ark blueman bluez-utils
    solaar qpwgraph exa bat ripgrep fzf zoxide entr mc gnome-themes-extra archlinux-xdg-menu inxi
    inotify-tools xdg-desktop-portal-gtk pipewire wireplumber swayidle
)

common_aur_packages=(
    ntfs-automount google-chrome-wayland-vulkan hyprshot tela-circle-icon-theme-dracula
    game-devices-udev zsh-theme-powerlevel10k-git espeak selectdefaultapplication-git
)

# Define CPU and GPU specific packages
declare -A cpu_packages=(
    [Intel]="cpupower thermald i7z"
    [AMD]="cpupower"
)

declare -A cpu_aur_packages=(
    [Intel]="cpupower-gui"
    [AMD]="cpupower-gui"
)

declare -A gpu_packages=(
    [AMD]="mesa vulkan-radeon xf86-video-amdgpu libva-mesa-driver mesa-vdpau"
    [NVIDIA]="nvidia nvidia-utils"
)

declare -A gpu_aur_packages=(
    [NVIDIA]="nvidia-settings nvidia-dkms"
)

# Define user-specific packages
declare -A user_specific_packages=(
    [unmedius]="ntfs-3g syncthing steam mangohud goverlay obsidian telegram-desktop scrcpy v4l2loopback-dkms gamescope gamemode"
    [jtv]=""
)

declare -A user_specific_aur_packages=(
    [unmedius]="syncthingtray-qt6 sunshine-bin vscodium battop"
    [jtv]=""
)

# Define machine-specific packages
declare -A machine_specific_packages=(
    [unArch]="package1 package2"
    [unArchLaptop]="package3 package4"
)

declare -A machine_specific_aur_packages=(
    [unArch]="aur_package1 aur_package2"
    [unArchLaptop]="aur_package3 aur_package4"
)

# Determine the current user and machine
current_user=$(whoami)
current_machine=$(hostname)

# Function to detect CPU and GPU
detect_hardware() {
    cpu_vendor=$(lscpu | grep 'Vendor ID:' | awk '{print $3}')
    gpu_info=$(lspci | grep -E 'VGA|3D')
}

# Function to select CPU and GPU packages
select_packages() {
    case $cpu_vendor in
        GenuineIntel) cpu_vendor="Intel" ;;
        AuthenticAMD) cpu_vendor="AMD" ;;
        *) echo "Unknown CPU vendor: $cpu_vendor"; cpu_vendor="" ;;
    esac

    if echo "$gpu_info" | grep -iq 'AMD'; then
        gpu_vendor="AMD"
    elif echo "$gpu_info" | grep -iq 'NVIDIA'; then
        gpu_vendor="NVIDIA"
    else
        echo "Unknown GPU or no dedicated GPU found."
        gpu_vendor=""
    fi
}

# Function to update and install packages
update_and_install_packages() {
    local package_manager=$1
    shift
    local packages=("$@")

    echo "Updating system with $package_manager..."
    sudo $package_manager -Syu --noconfirm

    echo "Checking and installing necessary packages with $package_manager..."
    for package in "${packages[@]}"; do
        if ! $package_manager -Qi "$package" &> /dev/null; then
            echo "Installing $package..."
            sudo $package_manager -S "$package" --noconfirm
        else
            echo "$package is already installed."
        fi
    done
}

# Main script execution
main() {
    detect_hardware
    select_packages

    # Combine all packages
    packages=("${common_packages[@]}")
    aur_packages=("${common_aur_packages[@]}")

    if [[ -n "${cpu_vendor}" ]]; then
        packages+=(${cpu_packages[$cpu_vendor]})
        aur_packages+=(${cpu_aur_packages[$cpu_vendor]})
    fi

    if [[ -n "${gpu_vendor}" ]]; then
        packages+=(${gpu_packages[$gpu_vendor]})
        aur_packages+=(${gpu_aur_packages[$gpu_vendor]})
    fi

    if [[ -n "${user_specific_packages[$current_user]}" ]]; then
        packages+=(${user_specific_packages[$current_user]})
    fi

    if [[ -n "${user_specific_aur_packages[$current_user]}" ]]; then
        aur_packages+=(${user_specific_aur_packages[$current_user]})
    fi

    if [[ -n "${machine_specific_packages[$current_machine]}" ]]; then
        packages+=(${machine_specific_packages[$current_machine]})
    fi

    if [[ -n "${machine_specific_aur_packages[$current_machine]}" ]]; then
        aur_packages+=(${machine_specific_aur_packages[$current_machine]})
    fi

    # Update system with pacman and install packages
    update_and_install_packages "pacman" "${packages[@]}"

    # Ensure 'yay' is installed for AUR packages
    if ! command -v yay &> /dev/null; then
        echo "Installing 'yay' AUR helper..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi

    # Update system with yay and install AUR packages
    update_and_install_packages "yay" "${aur_packages[@]}"

    # Update XDG menu prefix
    export XDG_MENU_PREFIX=arch-
    kbuildsycoca6

    echo "All packages have been checked and installed as needed."
}

main "$@"
