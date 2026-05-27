#!/bin/bash
set -e

# ──────────────────────────────────────────
# Hacker Terminal Dotfiles - Installer
# ──────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Detect package manager ---
if command -v pacman &>/dev/null; then
    PM="pacman"
    INSTALL_CMD="sudo pacman -S --needed --noconfirm"
    AUR_INSTALL=""
    if command -v paru &>/dev/null; then
        AUR_INSTALL="paru -S --needed --noconfirm"
    elif command -v yay &>/dev/null; then
        AUR_INSTALL="yay -S --needed --noconfirm"
    fi
elif command -v apt &>/dev/null; then
    PM="apt"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf &>/dev/null; then
    PM="dnf"
    INSTALL_CMD="sudo dnf install -y"
else
    echo "Unsupported package manager. Install packages manually (see README)."
    PM="manual"
fi

# --- Install packages ---
echo "=== Installing packages... ==="

if [ "$PM" = "pacman" ]; then
    $INSTALL_CMD \
        i3-wm kitty polybar picom feh fish btop rofi dunst \
        redshift playerctl scrot maim xclip pamixer xob \
        polkit-gnome dex brightnessctl zen-browser-bin \
        ttf-meslo-nerd starship lightdm lightdm-gtk-greeter \
        autorandr alacritty htop neovim thunar cava newsboat darkman

    if [ -n "$AUR_INSTALL" ]; then
        $AUR_INSTALL i3lock-color asdf-vm 2>/dev/null || true
    fi

elif [ "$PM" = "apt" ]; then
    $INSTALL_CMD \
        i3 kitty polybar picom feh fish btop rofi dunst \
        redshift playerctl scrot maim xclip pamixer \
        policykit-1-gnome brightnessctl zen-browser \
        fonts-firacode starship lightdm lightdm-gtk-greeter \
        htop neovim thunar newsboat
    echo "Note: Install Meslo Nerd Font manually from https://github.com/ryanoasis/nerd-fonts/releases"
    echo "Note: Install asdf from https://asdf-vm.com/guide/getting-started.html"
elif [ "$PM" = "dnf" ]; then
    $INSTALL_CMD \
        i3 kitty polybar picom feh fish btop rofi dunst \
        redshift playerctl scrot maim xclip pamixer \
        polkit-gnome brightnessctl zen-browser \
        meslo-nerd-fonts starship lightdm lightdm-gtk-greeter \
        autorandr alacritty htop neovim thunar cava newsboat
    echo "Note: Install asdf from https://asdf-vm.com/guide/getting-started.html"
fi

# Install asdf via git for non-Arch systems (config.fish auto-detects)
if ! command -v asdf &>/dev/null && [ "$PM" != "pacman" ]; then
    echo "=== Installing asdf version manager... ==="
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.19.0 2>/dev/null || true
fi

# --- Deploy with stow ---
echo "=== Deploying dotfiles with stow... ==="

if ! command -v stow &>/dev/null; then
    if [ "$PM" = "pacman" ]; then
        sudo pacman -S --noconfirm stow
    elif [ "$PM" = "apt" ]; then
        sudo apt install -y stow
    elif [ "$PM" = "dnf" ]; then
        sudo dnf install -y stow
    fi
fi

# Check if a path is already managed by stow (any parent dir is a symlink into our repo)
is_stow_managed() {
    local dir="$1"
    while [ "$dir" != "$HOME" ]; do
        dir="$(dirname "$dir")"
        if [ -L "$dir" ]; then
            local link_target="$(readlink "$dir")"
            case "$link_target" in
                */.dotfiles/*|*/dotfiles/*) return 0 ;;
            esac
        fi
    done
    return 1
}

# Backup existing conflicting files
for pkg in i3 kitty newsboat opencode polybar picom btop fish dunst rofi nushell \
            redshift nvim starship home gtk qt desktop-env cava htop \
            greenclip Thunar alacritty autorandr applications volumeicon; do
    pkg_path="$SCRIPT_DIR/$pkg"
    [ -d "$pkg_path" ] || continue
    while IFS= read -r -d '' f; do
        target="$HOME/${f#$SCRIPT_DIR/$pkg/}"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            if is_stow_managed "$target"; then
                continue
            fi
            echo "  backing up $target → $target.bak"
            mv "$target" "$target.bak"
        fi
    done < <(find "$pkg_path" -type f -print0)
done

# Stow all packages
cd "$SCRIPT_DIR"
for pkg in i3 kitty newsboat opencode polybar picom btop fish dunst rofi nushell \
            redshift nvim starship home gtk qt desktop-env cava htop \
            greenclip Thunar alacritty autorandr applications volumeicon; do
    [ -d "$pkg" ] || continue
    stow -t "$HOME" "$pkg" 2>/dev/null && echo "  stow $pkg: OK" || echo "  stow $pkg: skipped (may already be linked)"
done

# --- Deploy system-level files ---
echo "=== Deploying system files... ==="
cd "$SCRIPT_DIR/system"
find . -type f | while read -r f; do
    f="${f#./}"
    sudo install -Dm"$(stat -c %a "$f")" "$f" "/$f"
done
sudo udevadm control --reload-rules 2>/dev/null || true
sudo sysctl --system 2>/dev/null || true
sudo systemctl daemon-reload
sudo systemctl enable worth-suspend.service

echo "=== Dark/light theme daemon ==="
cp ~/.config/kitty/colors-dark.conf ~/.config/kitty/colors.conf 2>/dev/null || true
systemctl --user daemon-reload
systemctl --user enable --now darkman 2>/dev/null || true
darkman set light 2>/dev/null || true

echo "=== Setting wallpaper ==="
feh --bg-fill ~/.config/i3/wallpaper.png 2>/dev/null || true

echo ""
echo "=== Done! ==="
echo "Reload i3:  Mod+Shift+C"
echo "Toggle theme: Fn+F12 (star key)"
echo "New terminal: kitty (transparency should work)"
echo "Browser:     Mod+W (zen-browser)"
echo "Cheatsheet:  F1"
echo "Power menu:  Mod+Shift+E"
