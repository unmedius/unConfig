#!/bin/bash

get_brightness_percent() {
    current_brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    brightness_percent=$((current_brightness * 100 / max_brightness))
    echo "$brightness_percent"
}

change_brightness() {
    brightnessctl set "$1"
}

case "$1" in
    i)
        change_brightness "+5%"
        ;;
    d)
        change_brightness "5%-"
        ;;
    *)
        echo "usage: $0 [i|d]"
        exit 1
esac

brightness_percent=$(get_brightness_percent)
echo "$brightness_percent" > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob 

