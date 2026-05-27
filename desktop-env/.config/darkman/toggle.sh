#!/bin/bash
STATE_FILE=/tmp/.theme-mode
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "light" ]; then
    echo "dark" > "$STATE_FILE"
    ~/.config/darkman/dark.sh
else
    echo "light" > "$STATE_FILE"
    ~/.config/darkman/light.sh
fi
