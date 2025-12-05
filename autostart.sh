#!/usr/bin/env bash

#
# This script is autostarted from dwm.c:
#   scan();
#   system("$HOME/.config/dwm/autostart.sh &");
#   run();
#

###############################################################################
# Startup applications
###############################################################################

export GTK_THEME="Adwaita:dark"

# Notification daemon
dunst &

# Status bar
dwmblocks &

###############################################################################
# Wallpaper
###############################################################################

WALLPAPER=""
if [ -f "$HOME/.config/dwm/wallpaper/gruvbox.png" ]; then
    WALLPAPER="$HOME/.config/dwm/wallpaper/gruvbox.png"
elif [ -f "/usr/local/share/dwm/wallpaper/gruvbox.png" ]; then
    WALLPAPER="/usr/local/share/dwm/wallpaper/gruvbox.png"
fi

if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
    if command -v feh >/dev/null 2>&1; then
        feh --bg-scale "$WALLPAPER" &
    elif command -v nitrogen >/dev/null 2>&1; then
        nitrogen --set-scaled "$WALLPAPER" &
    elif command -v xwallpaper >/dev/null 2>&1; then
        xwallpaper --zoom "$WALLPAPER" &
    fi
fi

