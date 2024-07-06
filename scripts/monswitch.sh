# Function to set monitor configuration
set_monitor() {
    local monitor=$1
    local settings=$2
    echo "Configuring monitor $monitor with settings $settings"
    hyprctl keyword monitor "$monitor", "$settings"
}

# Main case statement
case $1 in
    "l")
        set_monitor "HDMI-A-2" "disabled"
        set_monitor "DP-2" "3440x1440@165, 0x0, 1"
        ;;
    "r")
        set_monitor "DP-2" "disabled"
        set_monitor "HDMI-A-2" "3840x2160, 3440x0, 2"
        ;;
    "m")
        set_monitor "HDMI-A-2" "3840x2160, 0x0, 1.5"
        set_monitor "DP-2" "2560x1440, auto, auto, mirror, HDMI-A-2"
        ;;
    "j")
        set_monitor "HDMI-A-2" "3840x2160, 3440x0, 2"
        set_monitor "DP-2" "3440x1440@165, 0x0, 1"
        ;;
    *)
        echo "Usage: $0 {l|r|m|j}"
        exit 1
        ;;
esac
