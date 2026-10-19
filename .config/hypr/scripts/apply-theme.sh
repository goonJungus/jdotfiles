#!/bin/bash
# jdotfiles: restore the standard gtk/icon/font/cursor settings on set activation.
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
export XDG_RUNTIME_DIR=/run/user/$(id -u)
SIG=$(ls $XDG_RUNTIME_DIR/hypr/ 2>/dev/null | head -1)
[ -n "$SIG" ] && HYPRLAND_INSTANCE_SIGNATURE=$SIG hyprctl setcursor Adwaita 24 >/dev/null 2>&1
# hyprpaper needs the instance signature or its IPC socket lands wrong
[ -n "$SIG" ] && export HYPRLAND_INSTANCE_SIGNATURE=$SIG
pkill hyprpaper 2>/dev/null; sleep 0.3; (hyprpaper >/dev/null 2>&1 &)
(waypaper --restore >/dev/null 2>&1 &)
HYPRLAND_INSTANCE_SIGNATURE=$SIG hyprctl plugin unload "$HOME/xpdots/assets/hyprbars.so" >/dev/null 2>&1
exit 0
