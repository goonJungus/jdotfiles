#!/bin/bash
# jdotfiles installer: symlink this repo's .config into ~/.config
# Existing configs are backed up to ~/.config-backup-<date> first.
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"
APPS=(hypr waybar kitty rofi swaync wlogout waypaper)
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

for a in "${APPS[@]}"; do
    if [ -e "$REPO/.config/$a" ]; then
        if [ -e "$HOME/.config/$a" ] && [ ! -L "$HOME/.config/$a" ]; then
            mkdir -p "$BACKUP"
            cp -r "$HOME/.config/$a" "$BACKUP/$a"
            rm -rf "$HOME/.config/$a"
            echo "backed up existing $a"
        fi
        ln -sfn "$REPO/.config/$a" "$HOME/.config/$a"
        echo "linked $a"
    fi
done

mkdir -p "$HOME/.local/bin"
ln -sfn "$REPO/dots" "$HOME/.local/bin/dots"
echo "installed: dots (hot-swap switcher, run 'dots' for status)"
echo "done. Log out/in or run: hyprctl reload"
