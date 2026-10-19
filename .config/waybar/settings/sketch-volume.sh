#!/bin/bash
# j-sketch volume pill: teal speaker icon + slider track (matches sketchybar meter)
vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+(?=%)' | head -1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
[ -z "$vol" ] && exit 0
if [ "$mute" = "yes" ] || [ "$vol" -eq 0 ]; then icon=$(printf '\uf026'); elif [ "$vol" -lt 50 ]; then icon=$(printf '\uf027'); else icon=$(printf '\uf028'); fi
cells=8
filled=$(( (vol * cells + 50) / 100 ))
[ "$filled" -gt "$cells" ] && filled=$cells
[ "$filled" -lt 0 ] && filled=0
bar=""
for i in $(seq 1 $filled); do bar="${bar}━"; done
rest=$((cells - filled))
tail=""
for i in $(seq 1 $rest); do tail="${tail}─"; done
printf "<span color='#2dd4bf'>%s</span>  <span color='#2dd4bf'>%s</span><span color='#eef8f6'>●</span><span color='#33524d'>%s</span>" "$icon" "$bar" "$tail"
