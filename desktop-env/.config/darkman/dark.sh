#!/bin/bash

cp ~/.config/kitty/colors-dark.conf ~/.config/kitty/colors.conf 2>/dev/null || true
timeout 3 kitty @ set-colors --all --configured ~/.config/kitty/colors.conf 2>/dev/null || true
sed -i 's|catppuccin-latte|catppuccin-mocha|g' ~/.config/rofi/config.rasi 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

sed -i \
  -e 's|#eff1f5|#1e1e2e|g' \
  -e 's|#4c4f69|#cdd6f4|g' \
  -e 's|#1e66f5|#89b4fa|g' \
  -e 's|#40a02b|#a6e3a1|g' \
  -e 's|#d20f39|#f38ba8|g' \
  -e 's|#6c6f85|#6c7086|g' \
  -e 's|#ccd0da|#313244|g' \
  -e 's|#9ca0b0|#45475a|g' \
  -e 's|#acb0be|#585b70|g' \
  -e 's|#bcc0cc|#bac2de|g' \
  ~/.config/polybar/config 2>/dev/null || true
timeout 5 ~/.config/polybar/launch.sh 2>/dev/null || true

pkill dunst 2>/dev/null || true
dunst 2>/dev/null &

feh --bg-fill ~/.config/i3/wallpaper.png 2>/dev/null || true
timeout 3 i3-msg reload 2>/dev/null || true
