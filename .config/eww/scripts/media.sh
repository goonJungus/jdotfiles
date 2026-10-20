#!/bin/bash
# j-sketch eww media: play/pause glyph + title (empty hides the pill)
st=$(playerctl status 2>/dev/null) || exit 0
[ "$st" = "Stopped" ] && exit 0
title=$(playerctl metadata title 2>/dev/null)
[ -z "$title" ] && exit 0
if [ "${#title}" -gt 46 ]; then title="${title:0:46}…"; fi
if [ "$st" = "Playing" ]; then icon="▶"; else icon="❚❚"; fi
printf '%s  %s' "$icon" "$title"
