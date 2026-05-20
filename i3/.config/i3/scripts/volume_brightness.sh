#!/bin/bash

# Catppuccin Mocha colors
bar_color="#cba6f7"
muted_color="#6c7086"

volume_step=1
brightness_step=2.5
max_volume=100

function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_brightness {
    local current max_val
    current=$(brightnessctl get)
    max_val=$(brightnessctl max)
    echo $(( current * 100 / max_val ))
}

function show_volume_notif {
    local volume mute
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$mute" = "yes" ]; then
        dunstify -t 1000 -r 2593 -u normal "MUT  0%" \
            -h int:value:0 -h string:hlcolor:$muted_color
    else
        dunstify -t 1000 -r 2593 -u normal "VOL  ${volume}%" \
            -h int:value:$volume -h string:hlcolor:$bar_color
    fi
}

function show_brightness_notif {
    local brightness
    brightness=$(get_brightness)
    dunstify -t 1000 -r 2593 -u normal "BRT  ${brightness}%" \
        -h int:value:$brightness -h string:hlcolor:$bar_color
}

case $1 in
    volume_up)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        volume=$(get_volume)
        if [ $(( volume + volume_step )) -gt $max_volume ]; then
            pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
        fi
        show_volume_notif
        ;;

    volume_down)
        pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
        show_volume_notif
        ;;

    volume_mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;

    brightness_up)
        brightnessctl set "${brightness_step}%+" -q
        show_brightness_notif
        ;;

    brightness_down)
        brightnessctl set "${brightness_step}%-" -q
        show_brightness_notif
        ;;
esac
