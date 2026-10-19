#!/bin/bash
# j-sketch front-app pill: "> AppName" for the focused window's class
cls=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty' 2>/dev/null)
[ -n "$cls" ] && printf '›  %s' "$cls"
exit 0
