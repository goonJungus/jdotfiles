#!/bin/bash
# j: bar engine switch - eww (default) or waybar. Usage: bar.sh [eww|waybar|toggle|restart]
STATE=~/.config/hypr/bar-engine
engine=$(cat "$STATE" 2>/dev/null || echo eww)
case "$1" in
  eww|waybar) engine=$1; echo "$engine" > "$STATE" ;;
  toggle)
    if [ "$engine" = eww ]; then
      # eww 0.5 has no open --toggle: detect the bar surface (46px gtk-layer-shell) via hyprctl layers
      if hyprctl layers -j 2>/dev/null | jq -e '[.. | objects | select(.namespace? == "gtk-layer-shell" and .h == 46)] | length > 0' >/dev/null; then eww close bar; else eww open bar 2>/dev/null || { eww daemon & sleep 1; eww open bar; }; fi
    else ~/.config/waybar/toggle.sh; fi
    exit 0 ;;
  restart) ;;
  *) ;;
esac
if [ "$engine" = eww ]; then
  pkill waybar 2>/dev/null
  eww close-all 2>/dev/null; rm -f /tmp/eww-volpopup-open; sleep 0.3
  eww open bar 2>/dev/null || { eww daemon & sleep 1; eww open bar; }
else
  eww close-all 2>/dev/null; eww kill 2>/dev/null; rm -f /tmp/eww-volpopup-open
  ~/.config/waybar/launch.sh
fi
