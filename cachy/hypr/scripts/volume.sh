#!/bin/bash

# PID for focused window
PID=$(hyprctl activewindow -j | jq -r '.pid')

case "$1" in
  lower)
    pamixer -ud 3 
    pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
    ;;
  raise)
    pamixer -ui 3 
    pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
    ;;
  mute)
    pamixer -t
    echo '0' > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob 
    ;;
  lower-foc)
    wpctl set-volume -l 1.0 -p "$PID" 5%-
    # wpctl get-volume "$PID" > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
    ;;
  raise-foc)
    wpctl set-volume -l 1.0 -p "$PID" 5%+
    # wpctl get-volume "$PID" > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
    ;;
  mute-foc)
    wpctl set-mute -p "$PID" toggle
    # wpctl get-volume "$PID" > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
    ;;
  *)
    echo "Usage: $0 {lower|raise|mute}"
    exit 1
esac

