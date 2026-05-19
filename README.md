# dotfiles

Stow-managed dotfiles for a transparent "movie hacker" i3 setup.

## What's included

| Package | What |
|---------|------|
| `i3` | Zero borders, zero gaps, Catppuccin Mocha, powermenu, keyhint, media keys |
| `kitty` | Catppuccin Mocha with 85% background opacity |
| `polybar` | Matching status bar at the bottom |
| `picom` | GLX compositor with transparency rules |
| `btop` | Transparent Catppuccin Mocha theme |
| `fish` | Minimal hacker-style prompt |
| `rofi` | App launcher, powermenu, keyhint themes |
| `dunst` | Notification daemon config |
| `nushell` | Shell config |
| `lvim` | LunarVim config |
| `redshift` | Auto-brightness hooks |

## Keybindings

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal |
| `Mod+d` | App launcher (rofi) |
| `Mod+t` | Window switcher (rofi) |
| `Mod+b` | Btop (system monitor) |
| `Mod+w` | Firefox |
| `Mod+g` | GitUI |
| `F1` | Keybinding cheat sheet |
| `Mod+p` | Toggle polybar |
| `Mod+Shift+e` | Power menu |
| `Mod+Shift+p` | Power profiles |
| `Print` | Screenshot (full) |
| `Mod+Print` | Screenshot (selection) |

## Setup on a new machine

```bash
# Clone
git clone git@github.com:norbu09/dotfiles ~/.dotfiles

# Install packages (Arch)
sudo pacman -S --needed \
  i3-wm kitty polybar picom feh fish btop rofi dunst \
  redshift playerctl scrot pamixer xob maim polkit-gnome \
  ttf-meslo-nerd

# Deploy
cd ~/.dotfiles
stow .

# Reload i3
i3-msg reload
```
