#!/bin/sh

# Wait for DISPLAY
while [ -z "$DISPLAY" ]; do sleep 0.1; done

# Set wallpaper
"$(dirname "$0")/dwm-wallpaper.sh"

# Start status bar updater in background
"$(dirname "$0")/dwm-status.sh" &

# Start dwm
exec dwm

