#!/bin/bash

# Define common packages
common_packages=(
    hyprland
    wofi
    kitty
    dolphin
    xdg-desktop-portal-hyprland
    qt5-wayland
    qt6-wayland
    grim
    slurp
    polkit
    polkit-kde-agent
    sddm
    hyprpaper
    waybar
    zsh
    neovim
    firefox
    flatpak
    ttf-font-awesome
    pamixer
    qbittorrent
    pavucontrol
    btop
    qpwgraph
    htop
    vlc
    brightnessctl 
    unzip 
    ark 
    blueman 
    bluez-utils 
    solaar 
    qpwgraph 
    exa 
    bat 
    ripgrep 
    fzf 
    zoxide 
    entr 
    mc
    gnome-themes-extra
    archlinux-xdg-menu
)

common_aur_packages=(
    ntfs-automount
    hyprshot
    tela-circle-icon-theme-dracula
)

# Define packages for Intel CPUs
intel_cpu_packages=(
    cpupower
    thermald
    i7z
)

intel_cpu_aur_packages=(
    cpupower-gui
)

# Define packages for AMD CPUs
amd_cpu_packages=(
    cpupower
)

amd_cpu_aur_packages=(
    cpupower-gui
)

# Define packages for AMD GPUs
amd_gpu_packages=(
    mesa
    vulkan-radeon
    xf86-video-amdgpu
    libva-mesa-driver
    mesa-vdpau
)

amd_gpu_aur_packages=(
    # Add AUR packages for AMD GPUs if needed
)

# Define packages for NVIDIA GPUs
nvidia_gpu_packages=(
    nvidia
    nvidia-utils
)

nvidia_gpu_aur_packages=(
    nvidia-settings
    nvidia-dkms
)

# Determine the current user
current_user=$(whoami)

# Define user-specific packages
if [ "$current_user" == "unmedius" ]; then
    user_specific_packages=(
        ntfs-3g 
        syncthing 
        steam 
        mangohud 
        goverlay 
        obsidian 
        telegram-desktop 
        scrcpy 
        v4l2loopback-dkms
        gamescope
    )

    user_specific_aur_packages=(
        zsh-theme-powerlevel10k-git 
        syncthingtray-qt6 
        sunshine 
        vscodium 
        battop
    )

elif [ "$current_user" == "jtv" ]; then
    user_specific_packages=(
        # Add user-specific packages for "jtv" here
    )

    user_specific_aur_packages=(
        # Add user-specific AUR packages for "jtv" here
    )
else
    user_specific_packages=()
    user_specific_aur_packages=()
fi

# Detect CPU and GPU
cpu_vendor=$(lscpu | grep 'Vendor ID:' | awk '{print $3}')
gpu_info=$(lspci | grep -E 'VGA|3D')

# Initialize CPU and GPU specific packages
cpu_packages=()
cpu_aur_packages=()
gpu_packages=()
gpu_aur_packages=()

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
fi

# Combine all packages
packages=("${common_packages[@]}" "${cpu_packages[@]}" "${gpu_packages[@]}" "${user_specific_packages[@]}")
aur_packages=("${common_aur_packages[@]}" "${cpu_aur_packages[@]}" "${gpu_aur_packages[@]}" "${user_specific_aur_packages[@]}")

# Check and install necessary packages
echo "Checking and installing necessary packages for user $current_user..."
for package in "${packages[@]}"; do
    if pacman -Qi "$package" &> /dev/null; then
        echo "$package is already installed."
    else
        echo "Installing $package..."
        sudo pacman -S "$package" --noconfirm
    fi
done

# Ensure 'yay' is installed for AUR packages
if ! command -v yay &> /dev/null; then
    echo "Installing 'yay' AUR helper..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
fi

# Check and install necessary AUR packages
echo "Checking and installing necessary AUR packages for user $current_user..."
for aur_package in "${aur_packages[@]}"; do
    if yay -Qi "$aur_package" &> /dev/null; then
        echo "$aur_package is already installed."
    else
        echo "Installing $aur_package..."
        yay -S "$aur_package" --noconfirm
    fi
done

# Update XDG menu prefix
export XDG_MENU_PREFIX=arch-
kbuildsycoca6

echo "All packages have been checked and installed as needed."
