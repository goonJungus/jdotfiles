#!/bin/bash
# Connect from the wifi popup. Saved/open: direct. New secured: terminal asks the password.
SSID="$1"; SEC="$2"
if nmcli -t -f NAME connection show | grep -Fxq "$SSID"; then
  nmcli connection up "$SSID" >/dev/null 2>&1 || nmcli device wifi connect "$SSID" >/dev/null 2>&1
elif [ "$SEC" = '1' ]; then
  kitty -e nmcli -a device wifi connect "$SSID" >/dev/null 2>&1 &
else
  nmcli device wifi connect "$SSID" >/dev/null 2>&1
fi
~/.config/eww/scripts/wifitoggle.sh close
