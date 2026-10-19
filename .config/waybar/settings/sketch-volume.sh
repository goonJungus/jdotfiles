#!/bin/bash
# j-sketch volume pill: teal speaker icon + slider track (matches sketchybar meter)
vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+(?=%)' | head -1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
[ -z "$vol" ] && exit 0
if [ "$mute" = "yes" ] || [ "$vol" -eq 0 ]; then icon=$(printf ''); elif [ "$vol" -lt 50 ]; then icon=$(printf ''); else icon=$(printf ''); fi
if [ "$mute" = "yes" ]; then
  printf "<span color='#4d7d77'>%s</span>  %s%%" "$icon" "$vol"
else
  printf "<span color='#2dd4bf'>%s</span>  %s%%" "$icon" "$vol"
fi
