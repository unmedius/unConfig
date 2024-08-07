#!/usr/bin/env fish

# Check if the correct number of arguments is passed
if test (count $argv) -ne 1
    echo "Usage: monswitch <left, right, join, mirror, turn-off>"
    exit 1
end

set action $argv[1]

# Determine the command based on the action using a case statement
switch $action
    case "left"
        hyprctl keyword monitor DP-1,3440x1440@165,auto,auto
        hyprctl keyword monitor HDMI-A-2,disable
    case "right"
        hyprctl keyword monitor DP-1,disable
        hyprctl keyword monitor HDMI-A-2,3840x2160,auto,1.5
    case "join" 
        hyprctl keyword monitor DP-1,3440x1440@165,auto,auto
        hyprctl keyword monitor HDMI-A-2,3840x2160,auto,1.5
    case "mirror"
        hyprctl keyword monitor HDMI-A-2,3840x2160,auto,1.5
        hyprctl keyword monitor DP-1,2560x1440,auto,auto,mirror,HDMI-A-2
    case "turn-off"
        hyprctl keyword monitor HDMI-A-2, disable
        hyprctl keyword monitor DP-1, disable
    case '*'
        echo "Invalid action. Use <left, right, join, mirror>."
        exit 1
end

# Check the status of the command execution
if test $status -eq 0
    notify-send "Successfully selected $action."
else
    echo "Error attempting $action."
end
