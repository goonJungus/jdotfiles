#!/bin/bash
# j: system update — full yay (system + AUR) + flatpak, in a floating kitty
kitty --class dotfiles-floating -e bash -c "yay -Syu; flatpak update; flatpak uninstall --unused; echo; echo \"== Update finished ==\"; read -p \"Press Enter to close...\""
