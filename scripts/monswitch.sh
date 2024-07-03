#!/bin/bash

# Function to set monitor configuration
set_monitor() {
    local monitor=$1
    local settings=$2
    echo "Configuring monitor $monitor with settings $settings"
    hyprctl keyword monitor "$monitor", "$settings"
}

# Function to set default audio sink
set_audio_sink() {
    local sink_type=$1
    local sink=$(pactl list short sinks | grep "$sink_type" | awk '{print $1}')
    if [ -n "$sink" ]; then
        echo "Setting default audio sink to $sink_type"
        pactl set-default-sink "$sink"
    else
        echo "No audio sink found for $sink_type"
    fi
}

# Main case statement
case $1 in
    "l")
        set_monitor "HDMI-A-2" "disabled"
        set_monitor "DP-2" "3440x1440@165, 0x0, 1"
        set_audio_sink "analog"
        ;;
    "r")
        set_monitor "DP-2" "disabled"
        set_monitor "HDMI-A-2" "3840x2160, 3440x0, 2"
        set_audio_sink "hdmi"
        ;;
    "m")
        set_monitor "HDMI-A-2" "3840x2160, 0x0, 2"
        set_monitor "DP-2" "2560x1440, auto, auto, mirror, HDMI-A-2"
        set_audio_sink "hdmi"
        ;;
    "j")
        set_monitor "HDMI-A-2" "3840x2160, 3440x0, 2"
        set_monitor "DP-2" "3440x1440@165, 0x0, 1"
        set_audio_sink "hdmi"
        ;;
    *)
        echo "Usage: $0 {l|r|m|j}"
        exit 1
        ;;
esac
