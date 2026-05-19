#!/bin/bash

# Atomic lock — prevents duplicates even if two instances start simultaneously
exec 200>/tmp/.i3-watch-outputs.lock
flock -n 200 || exit 0

setup_displays() {
    if command -v autorandr &>/dev/null; then
        autorandr --change 2>/dev/null
    else
        ~/.config/i3/setup-displays.sh
    fi
}

set_wallpaper() {
    feh --bg-fill ~/.config/i3/wallpaper.png 2>/dev/null || true
}

# Run immediately on start
setup_displays
~/.config/i3/assign-workspaces.sh
set_wallpaper

prev=""
while true; do
    current=$(xrandr --query | awk '/ connected/ && /[0-9]+x[0-9]+[+-]/ {print $1}' | sort | tr '\n' ' ')
    if [ "$current" != "$prev" ] && [ -n "$current" ]; then
        prev="$current"
        setup_displays
        ~/.config/i3/assign-workspaces.sh
        set_wallpaper
    fi
    sleep 2
done
