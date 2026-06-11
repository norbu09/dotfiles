#!/bin/bash
STATE_FILE=/tmp/.theme-mode
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "light" ]; then
    echo "dark" > "$STATE_FILE"
    ~/.config/darkman/dark.sh
    darkman set dark 2>/dev/null || true
else
    echo "light" > "$STATE_FILE"
    ~/.config/darkman/light.sh
    darkman set light 2>/dev/null || true
fi
