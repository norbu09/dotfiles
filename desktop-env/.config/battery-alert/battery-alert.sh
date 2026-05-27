#!/bin/bash
set -e

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/battery-alert"
mkdir -p "$STATE_DIR"

CRITICAL=4
notified() { [ -f "$STATE_DIR/alerted_$1" ]; }
mark()      { touch "$STATE_DIR/alerted_$1"; }
clear_all() { rm -f "$STATE_DIR"/alerted_*; }

pct=
for bat in /sys/class/power_supply/BAT*; do
    [ -d "$bat" ] || continue
    s=$(cat "$bat/status" 2>/dev/null)
    c=$(cat "$bat/capacity" 2>/dev/null)

    if [ "$s" = "Discharging" ]; then
        [ -z "$pct" ] && pct=100
        [ "$c" -le "$pct" ] && pct=$c
    fi
done

# No discharging battery found — clear state and exit
[ -z "$pct" ] && { clear_all; exit 0; }

send() {
    local urg="$1" msg="$2"
    notify-send -u "$urg" -t 8000 "Battery" "$msg"
}

if [ "$pct" -le "$CRITICAL" ]; then
    send critical "Battery at ${pct}% — suspending now"
    sleep 2
    systemctl suspend
elif [ "$pct" -le 5 ] && ! notified 5; then
    send critical "Battery critically low (${pct}%) — plug in now"
    mark 5
elif [ "$pct" -le 10 ] && ! notified 10; then
    send normal "Battery low (${pct}%)"
    mark 10
elif [ "$pct" -le 20 ] && ! notified 20; then
    send normal "Battery at ${pct}%"
    mark 20
fi
