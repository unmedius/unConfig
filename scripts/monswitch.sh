#!/bin/bash

case $1 in
    "l")
        # Disable HDMI-A-2 and set DP-2 to specified settings
        hyprctl keyword monitor HDMI-A-2, disabled
        hyprctl keyword monitor DP-2, 3440x1440@165, 0x0, 1
        
        # Set default audio sink
        speakers=$(pactl list short sinks | grep analog | awk '{print $1}')
        pactl set-default-sink "$speakers"
        ;;

    "r")
        # Disable DP-2 and set HDMI-A-2 to specified settings
        hyprctl keyword monitor DP-2, disabled
        hyprctl keyword monitor HDMI-A-2, 3840x2160, 3440x0, 2
        
        # Set default audio sink
        hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
        pactl set-default-sink "$hdmi"
        ;;

    "m")
        # Configure HDMI-A-2 and mirror DP-2 to HDMI-A-2
        hyprctl keyword monitor HDMI-A-2, 3840x2160, 0x0, 2
        hyprctl keyword monitor DP-2, 2560x1440, auto, auto, mirror, HDMI-A-2
        
        # Set default audio sink
        hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
        pactl set-default-sink "$hdmi"
        ;;

    "j")
        # Set HDMI-A-2 and DP-2 to specified settings
        hyprctl keyword monitor HDMI-A-2, 3840x2160, 3440x0, 2
        hyprctl keyword monitor DP-2, 3440x1440@165, 0x0, 1
        
        # Set default audio sink
        hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
        pactl set-default-sink "$hdmi"
        ;;

    *)
        echo "Usage: $0 {l|r|m|j}"
        exit 1
        ;;
esac