#!/bin/bash

cp ~/.config/kitty/colors-light.conf ~/.config/kitty/colors.conf 2>/dev/null || true
if [ -S /tmp/kitty ]; then
  timeout 3 kitty @ --to unix:/tmp/kitty reload-config 2>/dev/null || true
fi
sed -i 's|catppuccin-mocha|catppuccin-latte|g' ~/.config/rofi/config.rasi 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'default' 2>/dev/null || true

sed -i \
  -e 's|#1e1e2e|#eff1f5|g' \
  -e 's|#cdd6f4|#4c4f69|g' \
  -e 's|#89b4fa|#1e66f5|g' \
  -e 's|#a6e3a1|#40a02b|g' \
  -e 's|#f38ba8|#d20f39|g' \
  -e 's|#6c7086|#6c6f85|g' \
  -e 's|#313244|#ccd0da|g' \
  -e 's|#45475a|#9ca0b0|g' \
  -e 's|#585b70|#acb0be|g' \
  -e 's|#bac2de|#bcc0cc|g' \
  ~/.config/polybar/config 2>/dev/null || true
timeout 5 ~/.config/polybar/launch.sh 2>/dev/null || true

pkill dunst 2>/dev/null || true
dunst 2>/dev/null &

feh --bg-fill ~/.config/i3/wallpaper-light.jpg 2>/dev/null || true
timeout 3 i3-msg reload 2>/dev/null || true
