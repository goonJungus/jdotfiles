#!/bin/bash
S=/tmp/eww-calpopup-open
if [ -f "$S" ]; then eww close calpopup; rm -f "$S"; else eww open calpopup; touch "$S"; fi
