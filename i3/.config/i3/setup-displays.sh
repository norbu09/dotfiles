#!/bin/bash
# Detect connected outputs and configure them dynamically

outputs=$(xrandr --query | grep " connected" | awk '{print $1}')
[ -z "$outputs" ] && exit 0
mapfile -t outs <<< "$outputs"

# Read preferred widths while xrandr output is fresh
declare -A widths
raw=$(xrandr --query)
for out in "${outs[@]}"; do
    mode=$(echo "$raw" | sed -n "/^$out connected/,/^[^ ]/p" | grep "+" | head -1 | awk '{print $1}')
    widths[$out]=$(echo "$mode" | cut -d'x' -f1)
done

# Turn everything on with preferred mode first
for out in "${outs[@]}"; do
    xrandr --output "$out" --auto
done

sleep 0.3

# Set primary (first output)
xrandr --output "${outs[0]}" --primary

# Position side by side
x=0
for out in "${outs[@]}"; do
    xrandr --output "$out" --pos ${x}x0
    x=$((x + ${widths[$out]:-1920}))
done
