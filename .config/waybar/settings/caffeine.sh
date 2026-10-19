#!/bin/bash
# j: caffeine status for waybar (coffee cup)
if pgrep -f "systemd-inhibit.*[C]affeine" > /dev/null; then
  printf '{"text": "\u2615", "class": "on", "tooltip": "Caffeine ON - screen stays awake. Click to turn off"}'
else
  printf '{"text": "\u2615", "class": "off", "tooltip": "Caffeine off - click to keep the screen awake"}'
fi
