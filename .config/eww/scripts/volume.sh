#!/usr/bin/env python3
# SketchyBar volume glyph thresholds: 0 off, 1-30 low, 31-60 medium, 61+ high
import json, re, subprocess
out = subprocess.run(["pactl", "get-sink-volume", "@DEFAULT_SINK@"], capture_output=True, text=True).stdout
m = re.search(r"(\d+)%", out)
vol = int(m.group(1)) if m else 0
mute = "yes" in subprocess.run(["pactl", "get-sink-mute", "@DEFAULT_SINK@"], capture_output=True, text=True).stdout
if mute or vol == 0:
    icon = "󰸈"
elif vol <= 30:
    icon = "󰕿"
elif vol <= 60:
    icon = "󰖀"
else:
    icon = "󰕾"
print(json.dumps({"vol": vol, "muted": mute, "icon": icon}))
