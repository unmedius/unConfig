#!/bin/bash

# hyprctl keyword monitor DP-2, disabled
# hyprctl keyword monitor HDMI-A-2, disabled

# hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
# speakers=$(pactl list short sinks | grep analog | awk '{print $1}')

case $1 in
    "l")
	    hyprctl keyword monitor HDMI-A-2, disabled
        hyprctl keyword monitor DP-2, 3440x1440@165, 0x0, 1
        speakers=$(pactl list short sinks | grep analog | awk '{print $1}')
	    pactl set-default-sink $speakers
        ;;
    "r")
        hyprctl keyword monitor DP-2, disabled
	    hyprctl keyword monitor HDMI-A-2, 3840x2160, 3440x0, 2
        hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
        pactl set-default-sink $hdmi
        ;;
    "m")
        hyprctl keyword monitor HDMI-A-2, 3840x2160, 0x0, 2
        hyprctl keyword monitor DP-2, 2560x1440, auto, auto, mirror, HDMI-A-2
        hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
        pactl set-default-sink $hdmi
        ;;
    "j")
        hyprctl keyword monitor HDMI-A-2, 3840x2160, 3440x0, 2
        hyprctl keyword monitor DP-2, 3440x1440@165, 0x0, 1
        hdmi=$(pactl list short sinks | grep hdmi | awk '{print $1}')
        pactl set-default-sink $hdmi
        ;;
esac

# hyprpaper & waybar
