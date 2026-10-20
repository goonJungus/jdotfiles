#!/usr/bin/env python3
import json, time
# SketchyBar calendar: os.date("%I:%M %p") (zero-padded) and "%m/%d/%y"
t = time.localtime()
print(json.dumps({"time": time.strftime("%I:%M %p"), "date": time.strftime("%m/%d/%y"), "day": t.tm_mday, "month": t.tm_mon, "year": t.tm_year}))
