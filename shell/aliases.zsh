# jdotfiles - my shell aliases and overrides.
# Loaded last (via ~/.zshrc_custom -> this file), so these win over any
# dotfiles set's stock aliases, whichever set is active.

# My editor is geany (the stock set exported nvim, which isn't installed)
export EDITOR=geany

# --- keepers ---
alias c='clear'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias ff='fastfetch'
alias nf='fastfetch'
alias pf='fastfetch'
alias v='$EDITOR'
alias vim='$EDITOR'
alias shutdown='systemctl poweroff'

# --- dead stock aliases, removed ---
unalias res1 res2 update-grub setkb Qtile 2>/dev/null
unalias ascii cleanup ts 2>/dev/null
unalias ***REMOVED*** ***REMOVED***-calendar ***REMOVED***-diagnosis ***REMOVED***-hyprland ***REMOVED***-hyprland-diagnosis ***REMOVED***-options ***REMOVED***-qtile-diagnosis ***REMOVED***-settings ***REMOVED***-sidebar ***REMOVED***-update 2>/dev/null

# --- bare yay updates everything: pacman + AUR, then flatpaks, then prune ---
yay() {
    if [ $# -eq 0 ]; then
        command yay -Syu
        flatpak update -y
        flatpak uninstall --unused -y
    else
        command yay "$@"
    fi
}
