#!/usr/bin/env python3
"""ws2-layout: whenever workspace 2 is entered while empty, build Q's layout:
    'kitty --override background=#000000 --override color0=#000000 --override foreground=#2dd4bf --override color2=#0f766e --override color10=#2dd4bf --override color7=#ccfbf1 --override color15=#f0fdfa -e zsh -c "cmatrix -b; exec zsh"',
   (Ctrl+C in the matrix window drops to a shell instead of closing it)."""
import glob, json, os, socket, subprocess, sys, time

RUNTIME = os.environ.get("XDG_RUNTIME_DIR", "/run/user/1000")
TRIO = [
    "kitty -e btop",
    "kitty -e tfm",
    'kitty --override background=#000000 --override foreground=#2dd4bf --override color2=#0f766e --override color10=#2dd4bf --override color7=#ccfbf1 --override color15=#f0fdfa -e zsh -c "cmatrix -b; exec zsh"',
]
last_launch = 0.0


def instance_dir():
    dirs = sorted(glob.glob(os.path.join(RUNTIME, "hypr", "*")))
    return dirs[0] if dirs else None


def hypr(*args):
    d = instance_dir()
    if not d:
        return ""
    env = dict(os.environ)
    env["HYPRLAND_INSTANCE_SIGNATURE"] = os.path.basename(d)
    env["XDG_RUNTIME_DIR"] = RUNTIME
    r = subprocess.run(["hyprctl", *args], capture_output=True, text=True, env=env)
    return r.stdout


def ws2_empty():
    try:
        for ws in json.loads(hypr("workspaces", "-j")):
            if ws["id"] == 2:
                return ws["windows"] == 0
    except Exception:
        pass
    return False


def build():
    global last_launch
    last_launch = time.time()
    for cmd in TRIO:
        hypr("dispatch", "exec", f"[workspace 2 silent] {cmd}")
        time.sleep(1.2)


def main():
    while True:
        d = instance_dir()
        if not d:
            time.sleep(5)
            continue
        sock_path = os.path.join(d, ".socket2.sock")
        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(sock_path)
            buf = ""
            while True:
                data = s.recv(4096).decode("utf-8", "replace")
                if not data:
                    break
                buf += data
                while "\n" in buf:
                    line, buf = buf.split("\n", 1)
                    if line.startswith("workspace>>"):
                        name = line.split(">>", 1)[1].strip()
                        if name == "2" and time.time() - last_launch > 10 and ws2_empty():
                            build()
        except OSError:
            time.sleep(3)
        finally:
            try:
                s.close()
            except Exception:
                pass


if __name__ == "__main__":
    main()
