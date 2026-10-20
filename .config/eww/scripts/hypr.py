#!/usr/bin/env python3
# j-sketch eww: hyprland state listener (workspaces + front app) -> JSON lines
import json, os, socket, subprocess, sys

def jout(cmd):
    try:
        return json.loads(subprocess.run(cmd, capture_output=True, text=True, timeout=3).stdout or "null")
    except Exception:
        return None

def state():
    wss = jout(["hyprctl", "workspaces", "-j"]) or []
    aw = jout(["hyprctl", "activeworkspace", "-j"]) or {}
    active_id = aw.get("id", 1)
    occ = {}
    for w in wss:
        occ[w["id"]] = w.get("windows", 0) > 0
    spaces = []
    for i in range(1, 11):
        spaces.append({"id": i, "active": i == active_id, "occupied": occ.get(i, False) or i == active_id})
    win = jout(["hyprctl", "activewindow", "-j"]) or {}
    cls = win.get("class", "") if isinstance(win, dict) else ""
    front = (cls[:1].upper() + cls[1:]) if cls else ""
    return {"workspaces": spaces, "frontapp": front}

def emit():
    print(json.dumps(state()), flush=True)

def main():
    rt = os.environ.get("XDG_RUNTIME_DIR", "/run/user/1000")
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE", "")
    if not sig:
        try:
            sig = sorted(os.listdir(os.path.join(rt, "hypr")))[0]
        except Exception:
            return
    # hyprctl subprocesses need the signature in THEIR env too; a bar restart
    # from SSH/dots may have spawned the daemon without it (blind listener).
    os.environ["HYPRLAND_INSTANCE_SIGNATURE"] = sig
    emit()
    path = os.path.join(rt, "hypr", sig, ".socket2.sock")
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(path)
    buf = b""
    while True:
        data = s.recv(4096)
        if not data:
            break
        buf += data
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            ev = line.decode("utf-8", "ignore").split(">>")[0]
            if ev in ("workspace", "activewindow", "openwindow", "closewindow",
                      "movewindow", "focusedmon", "createworkspace", "destroyworkspace"):
                emit()

if __name__ == "__main__":
    main()
