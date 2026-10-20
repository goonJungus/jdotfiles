#!/bin/bash
# Alternate square-corners theme for Arch: Hyprland rounding, eww bar, swaync.
# Usage: corners.sh [square|round]  (no arg prints the current mode)
STATE="$HOME/.local/state/arch-corners"
mkdir -p "$(dirname "$STATE")"
EWWD="$HOME/jdotfiles/.config/eww"
SWAYD="$HOME/jdotfiles/.config/swaync"
case "$1" in
  square)
    printf square > "$STATE"
    sed -i 's/^    rounding = .*/    rounding = 0/' "$HOME/jdotfiles/.config/hypr/hyprland.conf"
    ln -sf eww-square.scss "$EWWD/eww.scss"
    ln -sf style-square.css "$SWAYD/style.css" ;;
  round)
    printf round > "$STATE"
    sed -i 's/^    rounding = .*/    rounding = 10/' "$HOME/jdotfiles/.config/hypr/hyprland.conf"
    ln -sf eww-round.scss "$EWWD/eww.scss"
    ln -sf style-round.css "$SWAYD/style.css" ;;
  *) cat "$STATE" 2>/dev/null || echo round; exit 0 ;;
esac
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
SIG=$(ls "$XDG_RUNTIME_DIR/hypr/" 2>/dev/null | head -1)
[ -n "$SIG" ] && HYPRLAND_INSTANCE_SIGNATURE=$SIG hyprctl reload >/dev/null 2>&1
"$HOME/jdotfiles/.config/hypr/scripts/bar.sh" restart >/dev/null 2>&1
swaync-client -R >/dev/null 2>&1
swaync-client -rs >/dev/null 2>&1
echo "corners: $1"
