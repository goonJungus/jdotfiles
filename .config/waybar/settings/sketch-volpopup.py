#!/usr/bin/env python3
# j-sketch volume popup: a real draggable/clickable slider (waybar has none).
# Placement comes from Hyprland windowrules for class dev.jungus.volpopup.
# Toggle behavior: if already running, a second launch closes it.
import os
import signal
import subprocess
import sys

PIDFILE = "/tmp/sketch-volpopup.pid"


def alive(pid):
    try:
        os.kill(pid, 0)
        return True
    except OSError:
        return False


# --- toggle: close existing instance and exit ---
if os.path.exists(PIDFILE):
    try:
        old = int(open(PIDFILE).read().strip())
        if old != os.getpid() and alive(old):
            os.kill(old, signal.SIGTERM)
            os.unlink(PIDFILE)
            sys.exit(0)
    except (ValueError, OSError):
        pass

with open(PIDFILE, "w") as f:
    f.write(str(os.getpid()))

import gi

gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk  # noqa: E402


def get_vol():
    try:
        out = subprocess.run(
            ["pactl", "get-sink-volume", "@DEFAULT_SINK@"],
            capture_output=True, text=True, timeout=2,
        ).stdout
        import re
        m = re.search(r"(\d+)%", out)
        return int(m.group(1)) if m else 50
    except Exception:
        return 50


VOLUME_ICON = "\uf028"

CSS = b"""
window { background: transparent; }
.card {
    background: rgba(7, 16, 17, 0.96);
    border-radius: 6px;
    padding: 12px 16px;
}
.card label.icon { color: #2dd4bf; font-size: 16px; }
scale trough {
    min-height: 6px;
    border-radius: 3px;
    background: #33524d;
}
scale highlight {
    background: #2dd4bf;
    border-radius: 3px;
}
scale slider {
    min-width: 16px;
    min-height: 16px;
    border-radius: 999px;
    background: #eef8f6;
    box-shadow: none;
}
"""


def on_activate(app):
    provider = Gtk.CssProvider()
    provider.load_from_data(CSS)
    Gtk.StyleContext.add_provider_for_display(
        Gdk.Display.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    )

    win = Gtk.ApplicationWindow(application=app)
    win.set_decorated(False)
    win.set_default_size(276, 52)

    box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
    box.add_css_class("card")

    icon = Gtk.Label(label=VOLUME_ICON)
    icon.add_css_class("icon")
    box.append(icon)

    scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
    scale.set_value(get_vol())
    scale.set_draw_value(False)
    scale.set_size_request(210, -1)

    def changed(s):
        subprocess.run(
            ["pactl", "set-sink-volume", "@DEFAULT_SINK@", f"{int(s.get_value())}%"],
            capture_output=True, timeout=2,
        )

    scale.connect("value-changed", changed)
    box.append(scale)
    win.set_child(box)

    keys = Gtk.EventControllerKey()

    def on_key(c, keyval, keycode, state):
        if keyval == Gdk.KEY_Escape:
            win.close()
            return True
        return False

    keys.connect("key-pressed", on_key)
    win.add_controller(keys)

    import time

    born = time.time()
    focus = Gtk.EventControllerFocus()

    def on_leave(c):
        if time.time() - born > 0.4:
            win.close()

    focus.connect("leave", on_leave)
    win.add_controller(focus)

    def cleanup(*a):
        try:
            os.unlink(PIDFILE)
        except OSError:
            pass

    win.connect("close-request", cleanup)
    win.present()


app = Gtk.Application(application_id="dev.jungus.volpopup")
app.connect("activate", on_activate)
app.run([])
