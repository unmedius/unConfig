#!/usr/bin/env fish

while true
    set win (hyprctl clients | grep -oP '(?<=pid: )\w+')
    if test -z "$win"
        break
    end
    hyprctl dispatch closewindow pid:$win[1]
end
notify-send "All windows closed" --expire-time=1000

