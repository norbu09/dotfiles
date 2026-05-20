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
| `redshift` | Auto-brightness hooks |
| `nvim` | LazyVim with Catppuccin Mocha transparent theme |
| `starship` | Fast cross-shell prompt (Catppuccin Mocha, Elixir-aware) |
| `home` | Shell env (.profile), gitconfig, X11 startup (.xinitrc), ALSA/JACK audio routing, wallpaper script, user avatar |
| `gtk` | GTK3/4 dark theme (Yaru-prussiangreen) with caelestia CSS overrides |
| `qt` | Qt5/Qt6 Darkly theme with Papirus-Dark icons and Kvantum engine |
| `desktop-env` | Autostart (1Password, Nextcloud, Worth), xdg-portal config, dark mode manager, XDG desktop env |
| `cava` | Audio visualizer with Catppuccin-esque gradient colors |
| `htop` | Themed process monitor with caelestia color scheme |
| `greenclip` | Clipboard manager with image support |
| `Thunar` | File manager custom actions (Open Terminal Here) |
| `alacritty` | Solarized Dark terminal (fallback for kitty) |
| `autorandr` | Display auto-config profiles (laptop + 5 office setups) |
| `applications` | Custom desktop entries (brain, Claude Code URL handler, Worth) |
| `volumeicon` | System tray volume control with alsamixer |
| `newsboat` | RSS feed reader with Catppuccin Mocha theme |

## Dependencies

- **asdf** — version manager for Elixir, Erlang, Node.js (see `bin/setup-asdf.sh`)
- `.tool-versions` at `$HOME` pins exact versions

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
stow i3 kitty polybar picom btop fish dunst rofi nushell redshift nvim starship home gtk qt desktop-env cava htop greenclip Thunar alacritty autorandr applications volumeicon
i3-msg reload
```
