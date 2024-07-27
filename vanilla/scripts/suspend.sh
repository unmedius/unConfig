#!/bin/bash

swayidle -w \
    timeout 900 'hyprctl dispatch dpms off' \
    timeout 1800 'systemctl suspend' \
    resume 'hyprctl dispatch dpms on'
