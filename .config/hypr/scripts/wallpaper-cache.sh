#!/bin/bash

jdotfiles_cache_folder="$HOME/.cache/j/hyprland-dotfiles"

generated_versions="$jdotfiles_cache_folder/wallpaper-generated"

rm $generated_versions/*
echo ":: Wallpaper cache cleared"
notify-send "Wallpaper cache cleared"
