#!/bin/sh

# Installation script for dwm autostart

DWM_SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
AUTOSTART_SCRIPT="$DWM_SOURCE_DIR/autostart.sh"
WALLPAPER_DIR="$DWM_SOURCE_DIR/wallpaper"

# Determine installation directory
if [ -n "$XDG_DATA_HOME" ]; then
	INSTALL_DIR="$XDG_DATA_HOME/dwm"
elif [ -d "$HOME/.local/share" ]; then
	INSTALL_DIR="$HOME/.local/share/dwm"
else
	INSTALL_DIR="$HOME/.dwm"
fi

echo "Installing dwm autostart scripts to: $INSTALL_DIR"

# Create directory
mkdir -p "$INSTALL_DIR"

# Copy autostart script
if [ -f "$AUTOSTART_SCRIPT" ]; then
	cp "$AUTOSTART_SCRIPT" "$INSTALL_DIR/"
	chmod +x "$INSTALL_DIR/autostart.sh"
	echo "✓ Installed autostart.sh"
else
	echo "✗ Error: autostart.sh not found in $DWM_SOURCE_DIR"
	exit 1
fi

# Copy wallpaper directory
if [ -d "$WALLPAPER_DIR" ]; then
	cp -r "$WALLPAPER_DIR" "$INSTALL_DIR/"
	echo "✓ Installed wallpaper directory"
else
	echo "⚠ Warning: wallpaper directory not found in $DWM_SOURCE_DIR"
fi

echo ""
echo "Installation complete!"
echo "The autostart script will run automatically when dwm starts."
echo ""
echo "To test, restart dwm or run: $INSTALL_DIR/autostart.sh"

