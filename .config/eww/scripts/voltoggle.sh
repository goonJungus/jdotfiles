#!/bin/bash
# eww 0.5: no open --toggle and list-windows shows defined windows, so track state in a file
S=/tmp/eww-volpopup-open
if [ -f "$S" ]; then eww close volpopup; rm -f "$S"; else eww open volpopup; touch "$S"; fi
