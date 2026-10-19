#!/bin/bash
# j-sketch clock pill: teal time, white date (matches sketchybar calendar item)
d=$(date +'%I:%M %p|%m/%d/%y')
printf "<span color='#2dd4bf'>%s</span>   ·   %s" "${d%%|*}" "${d##*|}"
