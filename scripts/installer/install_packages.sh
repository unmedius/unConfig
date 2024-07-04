#!/bin/bash

# Define common packages
common_packages=(
    hyprland wofi kitty dolphin xdg-desktop-portal-hyprland  qt5-wayland qt6-wayland grim slurp
    polkit polkit-kde-agent sddm hyprpaper waybar zsh neovim flatpak ttf-font-awesome pamixer
    qbittorrent pavucontrol btop qpwgraph htop vlc brightnessctl unzip ark blueman bluez-utils
    solaar qpwgraph exa bat ripgrep fzf zoxide entr mc gnome-themes-extra archlinux-xdg-menu inxi
    inotify-tools xdg-desktop-portal-gtk pipewire wireplumber
)

common_aur_packages=(
    ntfs-automount google-chrome-wayland-vulkan hyprshot tela-circle-icon-theme-dracula
    game-devices-udev zsh-theme-powerlevel10k-git espeak selectdefaultapplication-git
)

# Define packages for Intel CPUs
intel_cpu_packages=(cpupower thermald i7z)
intel_cpu_aur_packages=(cpupower-gui)

# Define packages for AMD CPUs
amd_cpu_packages=(cpupower)
amd_cpu_aur_packages=(cpupower-gui)

# Define packages for AMD GPUs
amd_gpu_packages=(mesa vulkan-radeon xf86-video-amdgpu libva-mesa-driver mesa-vdpau)
amd_gpu_aur_packages=()

# Define packages for NVIDIA GPUs
nvidia_gpu_packages=(nvidia nvidia-utils)
nvidia_gpu_aur_packages=(nvidia-settings nvidia-dkms)

# Determine the current user
current_user=$(whoami)

# Define user-specific packages
declare -A user_specific_packages=(
    [unmedius]="ntfs-3g syncthing steam mangohud goverlay obsidian telegram-desktop scrcpy v4l2loopback-dkms gamescope gamemode"
    [jtv]=""
)

declare -A user_specific_aur_packages=(
    [unmedius]="syncthingtray-qt6 sunshine-bin vscodium battop"
    [jtv]=""
)

# Detect CPU and GPU
cpu_vendor=$(lscpu | grep 'Vendor ID:' | awk '{print $3}')
gpu_info=$(lspci | grep -E 'VGA|3D')

# Select CPU packages based on detected CPU vendor
case $cpu_vendor in
    GenuineIntel)
        cpu_packages=("${intel_cpu_packages[@]}")
        cpu_aur_packages=("${intel_cpu_aur_packages[@]}")
        ;;
    AuthenticAMD)
        cpu_packages=("${amd_cpu_packages[@]}")
        cpu_aur_packages=("${amd_cpu_aur_packages[@]}")
        ;;
    *)
        echo "Unknown CPU vendor: $cpu_vendor"
        cpu_packages=()
        cpu_aur_packages=()
        ;;
esac

# Select GPU packages based on detected GPU
if echo "$gpu_info" | grep -iq 'AMD'; then
    gpu_packages=("${amd_gpu_packages[@]}")
    gpu_aur_packages=("${amd_gpu_aur_packages[@]}")
elif echo "$gpu_info" | grep -iq 'NVIDIA'; then
    gpu_packages=("${nvidia_gpu_packages[@]}")
    gpu_aur_packages=("${nvidia_gpu_aur_packages[@]}")
else
    echo "Unknown GPU or no dedicated GPU found."
    gpu_packages=()
    gpu_aur_packages=()
fi

# Combine all packages
packages=("${common_packages[@]}" "${cpu_packages[@]}" "${gpu_packages[@]}")
aur_packages=("${common_aur_packages[@]}" "${cpu_aur_packages[@]}" "${gpu_aur_packages[@]}")

if [[ -n "${user_specific_packages[$current_user]}" ]]; then
    packages+=(${user_specific_packages[$current_user]})
fi

if [[ -n "${user_specific_aur_packages[$current_user]}" ]]; then
    aur_packages+=(${user_specific_aur_packages[$current_user]})
fi

# Function to update and install packages
update_and_install_packages() {
    echo "Updating system with $1..."
    $1 -Syu --noconfirm

    echo "Checking and installing necessary packages with $1..."
    for package in "${@:2}"; do
        if $1 -Qi "$package" &> /dev/null; then
            echo "$package is already installed."
        else
            echo "Installing $package..."
            sudo $1 -S "$package" --noconfirm
        fi
    done
}

# Update system with pacman and install packages
update_and_install_packages "sudo pacman" "${packages[@]}"

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
