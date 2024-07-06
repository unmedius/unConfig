#!/bin/bash

swayidle -w \
    timeout 90 'hyprctl dispatch dpms off' \
    timeout 210 'systemctl suspend' \
    resume 'hyprctl dispatch dpms on'
