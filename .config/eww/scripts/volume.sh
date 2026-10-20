#!/usr/bin/env python3
import json, re, subprocess
out = subprocess.run(["pactl", "get-sink-volume", "@DEFAULT_SINK@"], capture_output=True, text=True).stdout
m = re.search(r"(\d+)%", out)
vol = int(m.group(1)) if m else 0
mute = "yes" in subprocess.run(["pactl", "get-sink-mute", "@DEFAULT_SINK@"], capture_output=True, text=True).stdout
icon = "" if (mute or vol == 0) else ("" if vol < 50 else "")
print(json.dumps({"vol": vol, "muted": mute, "icon": icon}))
