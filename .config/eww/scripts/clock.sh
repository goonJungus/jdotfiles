#!/usr/bin/env python3
import json, time
print(json.dumps({"time": time.strftime("%I:%M %p").lstrip("0"), "date": time.strftime("%m/%d/%y")}))
