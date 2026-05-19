#!/bin/bash

# Get connected and enabled outputs (those showing a resolution)
outputs=$(xrandr --query | awk '/ connected/ && /[0-9]+x[0-9]+[+-]/ {print $1}' | sort)
count=$(echo "$outputs" | wc -l)

assign_ws() {
    i3-msg "workspace $1 output $2" > /dev/null 2>&1
}

case "$count" in
    0|1)
        output=$(echo "$outputs" | head -1)
        [ -z "$output" ] && exit 0
        for ws in 1 2 3 4 5 6 7 8 9 10; do
            assign_ws "$ws" "$output"
        done
        ;;
    *)
        mapfile -t outs <<< "$outputs"
        primary="${outs[0]}"
        secondary="${outs[1]}"
        for ws in 1 3 5 7 9; do
            assign_ws "$ws" "$primary"
        done
        for ws in 2 4 6 8 10; do
            assign_ws "$ws" "$secondary"
        done
        ;;
esac
