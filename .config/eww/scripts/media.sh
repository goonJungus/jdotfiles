#!/usr/bin/env python3
# j-sketch eww media: SketchyBar media item - "Title  \u2022  Artist", max 36 chars,
# play/pause glyph state, idle text when nothing is playing.
import json, subprocess

def pc(*args):
    try:
        return subprocess.run(["playerctl", *args], capture_output=True, text=True, timeout=3).stdout.strip()
    except Exception:
        return ""

st = pc("status")
if st not in ("Playing", "Paused"):
    print(json.dumps({"text": "", "playing": False, "present": False}))
else:
    title = pc("metadata", "title")
    artist = pc("metadata", "artist")
    line = (title + "  \u2022  " + artist) if artist else title
    if len(line) > 36:
        line = line[:36]
    print(json.dumps({"text": line, "playing": st == "Playing", "present": True}))
