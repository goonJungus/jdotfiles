#!/usr/bin/env python3
# Nearby Wi-Fi networks for the wifi popup (scan results, not saved profiles).
import json, subprocess
nets = []
try:
    out = subprocess.run(['nmcli','-t','-f','SSID,SIGNAL,SECURITY,IN-USE','dev','wifi','list'],
                         capture_output=True, text=True, timeout=8).stdout
    seen = set()
    for line in out.splitlines():
        parts = line.split(':')
        if len(parts) < 4: continue
        ssid, sig, sec, inuse = parts[0].strip(), parts[1], parts[2], parts[3]
        if not ssid or ssid in seen: continue
        seen.add(ssid)
        secured = sec.strip() not in ('', '--')
        nets.append({'ssid': ssid, 'signal': int(sig or 0), 'secured': secured,
                     'active': inuse.strip() == '*',
                     'meta': (sig or '0') + '%' + (' lock' if secured else '')})
    nets.sort(key=lambda n: -n['signal'])
except Exception: pass
print(json.dumps({'networks': nets[:10]}))
