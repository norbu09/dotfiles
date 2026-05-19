#!/bin/bash

# PID file to prevent duplicate instances
pidfile="/tmp/.i3-watch-outputs.pid"
if [ -f "$pidfile" ]; then
    oldpid=$(cat "$pidfile")
    if kill -0 "$oldpid" 2>/dev/null; then
        kill "$oldpid" 2>/dev/null
        sleep 0.2
    fi
fi
echo $$ > "$pidfile"

# Re-set wallpaper after display changes
set_wallpaper() {
    feh --bg-fill ~/.config/i3/wallpaper.png 2>/dev/null || true
}

# Run immediately on start
~/.config/i3/setup-displays.sh
~/.config/i3/assign-workspaces.sh
set_wallpaper

prev=""
while true; do
    current=$(xrandr --query | awk '/ connected/ && /[0-9]+x[0-9]+[+-]/ {print $1}' | sort | tr '\n' ' ')
    if [ "$current" != "$prev" ] && [ -n "$current" ]; then
        prev="$current"
        ~/.config/i3/setup-displays.sh
        ~/.config/i3/assign-workspaces.sh
        set_wallpaper
    fi
    sleep 2
done
