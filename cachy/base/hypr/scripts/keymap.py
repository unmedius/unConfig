#!/usr/bin/env python3

import json
import subprocess

def get_keyboard_layout():
    result = subprocess.run(['hyprctl', 'devices', '-j'], stdout=subprocess.PIPE)
    devices_info = json.loads(result.stdout.decode('utf-8'))

    # Находим текущую раскладку клавиатуры
    for device in devices_info['keyboards']:
        if device['main']:
            layout = device['active_keymap']
            return layout

    return "Unknown"

if __name__ == "__main__":
    layout = get_keyboard_layout()
    subprocess.run(['notify-send', layout.lower()[:2], "Current Layout ", "--icon=/usr/share/iso-flag-png/" + layout.lower()[:2] + ".png", "--expire-time=1000"])

