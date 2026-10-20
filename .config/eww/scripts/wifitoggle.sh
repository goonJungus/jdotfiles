#!/bin/bash
S=/tmp/eww-wifipopup-open
if [ "$1" = 'close' ] || [ -f "$S" ]; then eww close wifipopup; rm -f "$S";
else nmcli device wifi rescan 2>/dev/null & eww open wifipopup; touch "$S"; fi
