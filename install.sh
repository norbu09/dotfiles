#!/bin/bash
set -e

# ──────────────────────────────────────────
# Worth Hacker Terminal Setup - Installer
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
        redshift pamixer xob maim polkit-gnome \
        ttf-meslo-nerd

    if [ -n "$AUR_INSTALL" ]; then
        $AUR_INSTALL i3lock-color 2>/dev/null || true
    fi
elif [ "$PM" = "apt" ]; then
    $INSTALL_CMD \
        i3 kitty polybar picom feh fish btop rofi dunst \
        redshift pavucontrol maim policykit-1-gnome \
        fonts-firacode fonts-hack-ttf
    echo "Note: Install Meslo Nerd Font manually from https://github.com/ryanoasis/nerd-fonts/releases"
elif [ "$PM" = "dnf" ]; then
    $INSTALL_CMD \
        i3 kitty polybar picom feh fish btop rofi dunst \
        redshift pamixer maim polkit-gnome \
        'fontpackages-filesystem' meslo-nerd-fonts
fi

# --- Create config directories ---
echo "=== Deploying configs... ==="
mkdir -p ~/.config/i3
mkdir -p ~/.config/kitty
mkdir -p ~/.config/polybar
mkdir -p ~/.config/picom
mkdir -p ~/.config/btop/themes
mkdir -p ~/.config/fish

# --- Copy configs ---
cp "$SCRIPT_DIR/i3/config" ~/.config/i3/config
cp "$SCRIPT_DIR/i3/watch-outputs.sh" ~/.config/i3/watch-outputs.sh 2>/dev/null || true
cp "$SCRIPT_DIR/i3/setup-displays.sh" ~/.config/i3/setup-displays.sh 2>/dev/null || true
cp "$SCRIPT_DIR/i3/assign-workspaces.sh" ~/.config/i3/assign-workspaces.sh 2>/dev/null || true
cp "$SCRIPT_DIR/i3/wallpaper.png" ~/.config/i3/wallpaper.png

cp "$SCRIPT_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf

cp "$SCRIPT_DIR/polybar/config" ~/.config/polybar/config
cp "$SCRIPT_DIR/polybar/launch.sh" ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/launch.sh

cp "$SCRIPT_DIR/picom/picom.conf" ~/.config/picom/picom.conf

cp "$SCRIPT_DIR/btop/btop.conf" ~/.config/btop/btop.conf
cp "$SCRIPT_DIR/btop/themes/catppuccin_mocha_transparent.theme" ~/.config/btop/themes/

cp "$SCRIPT_DIR/fish/config.fish" ~/.config/fish/config.fish

# --- Set wallpaper ---
feh --bg-fill ~/.config/i3/wallpaper.png 2>/dev/null || true

echo ""
echo "=== Done! ==="
echo "Reload i3 with Mod+Shift+C or log out and back in."
echo "Open a new kitty terminal to see transparency."
echo "Launch btop with Mod+B to see the transparent theme."
