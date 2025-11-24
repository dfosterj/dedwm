#!/bin/sh

# Set wallpaper
WALLPAPER_DIR="$(dirname "$0")/wallpaper"
WALLPAPER="$WALLPAPER_DIR/drwp1.jpeg"

if [ -f "$WALLPAPER" ]; then
	if command -v feh >/dev/null 2>&1; then
		feh --bg-scale "$WALLPAPER" &
	elif command -v nitrogen >/dev/null 2>&1; then
		nitrogen --set-scaled "$WALLPAPER" &
	elif command -v xwallpaper >/dev/null 2>&1; then
		xwallpaper --zoom "$WALLPAPER" &
	fi
fi

