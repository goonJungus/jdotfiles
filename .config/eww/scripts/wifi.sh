#!/usr/bin/env python3
import json, subprocess
ssid = ""
try:
    out = subprocess.run(["nmcli", "-t", "-f", "active,ssid", "dev", "wifi"],
                         capture_output=True, text=True, timeout=5).stdout
    for line in out.splitlines():
        if line.startswith("yes:"):
            ssid = line[4:]
            break
except Exception:
    pass
icon = "󰖩" if ssid else "󰖪"
print(json.dumps({"ssid": ssid, "icon": icon}))
