# jdotfiles

My Hyprland dotfiles for Arch Linux. One folder, symlinked into `~/.config` — everything is edited right here.

## What's inside

- **Hyprland** — single-file config (`master` layout, animations always on, blur off for performance)
- **Waybar** — 6 themes (`j`, `j-blur`, `j-minimal`, `j-modern`, `default`, `starter`), dark/light variants
- **Kitty** — terminal with cursor trail
- **Rofi** — launcher
- **SwayNC** — notifications / control center
- **Wlogout, Waypaper, nwg-dock** — logout menu, wallpaper, dock
- **`dots`** — hot-swap the whole setup live, no logout (see below)

## Install

```bash
git clone <this repo> ~/jdotfiles
cd ~/jdotfiles
./install.sh
```

Existing configs are backed up to `~/.config-backup-<date>` before linking.

## Hot-swapping (`dots`)

```
dots            # show the active set
dots jdotfiles  # this set
dots classic    # the stock set in ~/dotfiles
dots <folder>   # any dotfiles folder in ~ with a .config/hypr inside
```

It repoints every `~/.config` symlink and reloads Hyprland, Waybar, SwayNC and the dock live.

## Keybinds

Modifier is **Super**. The same scheme runs on my Mac with **Option** in the same spots.

| Keys | Action |
|---|---|
| Super + `` ` `` | Terminal (kitty) |
| Super + B | Browser (firefox) |
| Super + R | Files (nemo) |
| Super + E | Launcher (rofi) |
| Super + G | Editor (geany) |
| Super + V | Clipboard history |
| Super + Q / Super + Shift + Q | Close window / kill app |
| Super + F / M / T | Fullscreen / maximize / floating |
| Super + X / Super + Shift + X | Split orientation next / prev |
| Super + 1–0, arrows, scroll | Workspaces |
| Super + L | Lock |
| Super + Shift + R | Reload config |
| Super + Shift + B | Restart waybar |

## Update everything

Bare `yay` (no arguments) updates the whole system: pacman + AUR, then Flatpaks, then prunes unused Flatpak runtimes.
