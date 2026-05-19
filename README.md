# Worth Hacker Terminal Setup

One-font, no-borders, transparent-terminal "movie hacker" look for i3.

## What this does

- **Kitty** with 85% opacity — wallpaper visible behind terminals
- **i3** with zero borders, zero gaps, no titlebars — seamless tiling
- **Polybar** matching the terminal aesthetic, slightly transparent
- **Picom** with GLX backend for proper transparency compositing
- **Btop** with transparent Catppuccin Mocha theme
- **Fish** with minimal hacker-style prompt
- **Submarine cable map** wallpaper

## Packages needed

### Arch / CachyOS
```
sudo pacman -S --needed \
  i3-wm kitty polybar picom feh fish btop rofi dunst \
  redshift pamixer xob maim polkit-gnome \
  ttf-meslo-nerd
```

### Debian / Ubuntu
```
sudo apt install -y \
  i3 kitty polybar picom feh fish btop rofi dunst \
  redshift pavucontrol maim policykit-1-gnome \
  fonts-firacode fonts-hack-ttf
```
Then install Meslo Nerd Font manually from
https://github.com/ryanoasis/nerd-fonts/releases

### Fedora
```
sudo dnf install -y \
  i3 kitty polybar picom feh fish btop rofi dunst \
  redshift pamixer maim polkit-gnome \
  meslo-nerd-fonts
```

## Quick install

```bash
chmod +x install.sh && ./install.sh
```

Or copy individual configs manually:

| Component | Location |
|-----------|----------|
| i3        | `~/.config/i3/config` |
| Kitty     | `~/.config/kitty/kitty.conf` |
| Polybar   | `~/.config/polybar/config` |
| Picom     | `~/.config/picom/picom.conf` |
| Btop      | `~/.config/btop/btop.conf` |
| Fish      | `~/.config/fish/config.fish` |
| Wallpaper | `~/.config/i3/wallpaper.png` |

## Keybindings

| Key | Action |
|-----|--------|
| `Mod+Return` | Open terminal |
| `Mod+d` | App launcher (rofi) |
| `Mod+b` | Btop (system monitor) |
| `Mod+g` | GitUI |
| `Mod+p` | Toggle polybar |
| `Mod+l` | Lock screen |
| `Mod+f` | Fullscreen toggle |
| `Mod+Shift+c` | Reload i3 config |

## After install

1. Reload i3: `Mod+Shift+C`
2. Open a new kitty terminal
3. Launch btop: `Mod+B`
4. Log out and back in if anything doesn't work
