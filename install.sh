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
        polkit-gnome dex zen-browser-bin \
        ttf-meslo-nerd

    if [ -n "$AUR_INSTALL" ]; then
        $AUR_INSTALL i3lock-color 2>/dev/null || true
    fi
elif [ "$PM" = "apt" ]; then
    $INSTALL_CMD \
        i3 kitty polybar picom feh fish btop rofi dunst \
        redshift playerctl scrot maim xclip pamixer \
        policykit-1-gnome zen-browser \
        fonts-firacode
    echo "Note: Install Meslo Nerd Font manually from https://github.com/ryanoasis/nerd-fonts/releases"
elif [ "$PM" = "dnf" ]; then
    $INSTALL_CMD \
        i3 kitty polybar picom feh fish btop rofi dunst \
        redshift playerctl scrot maim xclip pamixer \
        polkit-gnome zen-browser \
        meslo-nerd-fonts
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
for pkg in i3 kitty polybar picom btop fish dunst rofi nushell redshift nvim starship; do
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
for pkg in i3 kitty newsboat opencode polybar picom btop fish dunst rofi nushell redshift nvim starship; do
    [ -d "$pkg" ] || continue
    stow -t "$HOME" "$pkg" 2>/dev/null && echo "  stow $pkg: OK" || echo "  stow $pkg: skipped (may already be linked)"
done

# --- Deploy system-level files ---
echo "=== Deploying system files... ==="
cd "$SCRIPT_DIR/system"
find . -type f | while read -r f; do
    f="${f#./}"
    sudo cp "$f" "/$f"
done
sudo udevadm control --reload-rules 2>/dev/null || true
sudo sysctl --system 2>/dev/null || true
sudo systemctl daemon-reload
sudo systemctl enable worth-suspend.service

echo "=== Setting wallpaper... ==="
feh --bg-fill ~/.config/i3/wallpaper.png 2>/dev/null || true

echo ""
echo "=== Done! ==="
echo "Reload i3:  Mod+Shift+C"
echo "New terminal: kitty (transparency should work)"
echo "Browser:     Mod+W (zen-browser)"
echo "Cheatsheet:  F1"
echo "Power menu:  Mod+Shift+E"
