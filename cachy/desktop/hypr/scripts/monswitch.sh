#!/bin/bash

# Check if the correct number of arguments is passed
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: monswitch <left, right, join, mirror, turn-off> [--silent]"
    exit 1
fi

action="$1"
silent=false

# Check if --silent is passed as the second argument
if [ "$#" -eq 2 ] && [ "$2" == "--silent" ] || [ "$2" == "silent" ]; then
    silent=true
fi

# Determine the command based on the action using a case statement
case "$action" in
    "left")
        hyprctl keyword monitor DP-1,3440x1440@165,auto,auto
        hyprctl keyword monitor HDMI-A-2,disable
        ;;
    "right")
        hyprctl keyword monitor DP-1,disable
        hyprctl keyword monitor HDMI-A-2,3840x2160,auto,1.5
        ;;
    "join")
        hyprctl keyword monitor DP-1,3440x1440@165,auto,auto
        hyprctl keyword monitor HDMI-A-2,3840x2160,auto,1.5
        ;;
    "mirror")
        hyprctl keyword monitor HDMI-A-2,3840x2160,auto,1.5
        hyprctl keyword monitor DP-1,2560x1440,auto,auto,mirror,HDMI-A-2
        ;;
    "turn-off")
        hyprctl keyword monitor HDMI-A-2,disable
        hyprctl keyword monitor DP-1,disable
        ;;
    *)
        echo "Invalid action. Use <left, right, join, mirror, turn-off>"
        exit 1
        ;;
esac

# Check the status of the command execution
if [ "$?" -eq 0 ]; then
    if ! $silent; then
        notify-send "Successfully selected $action."
    fi
else
    echo "Error attempting $action."
fi

