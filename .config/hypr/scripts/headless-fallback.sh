#!/bin/bash
# headless-fallback: if no real monitor is connected, create a virtual
# 1080p output so the session (and Sunshine) always has a display.
# With a TV/monitor attached this does nothing.
sleep 2
for i in $(seq 1 15); do
    hyprctl monitors >/dev/null 2>&1 && break
    sleep 2
done
if hyprctl monitors | grep -q "Monitor HDMI-A-1"; then
    exit 0
fi
if ! hyprctl monitors | grep -q "Monitor HEADLESS"; then
    hyprctl output create headless
    sleep 1
    hyprctl keyword monitor "HEADLESS-1, 1600x900@60, 0x0, 1"
fi
