#!/usr/bin/env sh

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    case $m in
      DP-1) MONITOR=$m polybar --reload main & disown ;;
      eDP-1) MONITOR=$m polybar --reload laptop & disown ;;
      *) MONITOR=$m polybar --reload main & disown ;;
    esac
  done
else
  polybar --reload main & disown
fi
