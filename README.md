# dotfiles

Stow-managed dotfiles for a transparent "movie hacker" i3 setup.

## Packages required

### Arch / CachyOS
```bash
sudo pacman -S --needed \
  i3-wm kitty polybar picom feh fish btop rofi dunst \
  redshift playerctl scrot maim xclip pamixer xob \
  polkit-gnome dex stow zen-browser-bin \
  ttf-meslo-nerd
```

### Debian / Ubuntu
```bash
sudo apt install -y \
  i3 kitty polybar picom feh fish btop rofi dunst \
  redshift playerctl scrot maim xclip pamixer \
  policykit-1-gnome dex stow zen-browser \
  fonts-firacode
```
Then install Meslo Nerd Font manually from https://github.com/ryanoasis/nerd-fonts

### Fedora
```bash
sudo dnf install -y \
  i3 kitty polybar picom feh fish btop rofi dunst \
  redshift playerctl scrot maim xclip pamixer \
  polkit-gnome dex stow zen-browser \
  meslo-nerd-fonts
```

## Quick install

```bash
git clone git@github.com:norbu09/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's included

| Package | Contents |
|---------|----------|
| `i3` | Zero borders/gaps, Catppuccin Mocha, powermenu, keyhint, media keys, scripts |
| `kitty` | Catppuccin Mocha with 85% background opacity |
| `polybar` | Status bar matching the terminal aesthetic |
| `picom` | GLX compositor for transparency |
| `btop` | Transparent Catppuccin Mocha theme |
| `fish` | Minimal hacker-style prompt |
| `rofi` | App launcher, powermenu, keyhint themes |
| `dunst` | Notification daemon |
| `nushell` | Nu shell config |
| `lvim` | LunarVim config |
| `redshift` | Auto-brightness hooks |

## Keybindings

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal |
| `Mod+d` | App launcher (rofi) |
| `Mod+Tab` | Window switcher (rofi) |
| `Mod+b` | Btop (system monitor) |
| `Mod+w` | Zen Browser |
| `Mod+g` | GitUI |
| `Mod+l` | Lock screen |
| `F1` | Keybinding cheat sheet |
| `Mod+p` | Toggle polybar |
| `Mod+Shift+e` | Power menu |
| `Mod+Shift+p` | Power profiles |
| `Mod+Shift+n` | Empty workspace |
| `Print` | Screenshot (full) |
| `Mod+Print` | Screenshot (selection) |

## Manual deploy with stow

```bash
cd ~/.dotfiles
stow i3 kitty polybar picom btop fish dunst rofi nushell lvim redshift
i3-msg reload
```
