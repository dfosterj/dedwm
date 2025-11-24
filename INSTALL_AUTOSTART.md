# Installing Autostart Scripts

The autostart patch allows dwm to automatically run scripts on startup. The patch looks for scripts in the following directories (in order):

1. `$XDG_DATA_HOME/dwm` (if `$XDG_DATA_HOME` is set)
2. `$HOME/.local/share/dwm`
3. `$HOME/.dwm`

## Installation

### Quick Install

Run the install script from the dwm source directory:

```bash
./install-autostart.sh
```

Or manually:

```bash
# Option 1: Use XDG directory (recommended)
mkdir -p ~/.local/share/dwm
cp autostart.sh ~/.local/share/dwm/
chmod +x ~/.local/share/dwm/autostart.sh

# Copy wallpaper directory
cp -r wallpaper ~/.local/share/dwm/

# Option 2: Use traditional ~/.dwm directory
mkdir -p ~/.dwm
cp autostart.sh ~/.dwm/
chmod +x ~/.dwm/autostart.sh

# Copy wallpaper directory
cp -r wallpaper ~/.dwm/
```

## What the script does

The `autostart.sh` script:
- Sets the wallpaper from `wallpaper/drwp1.jpeg` (looks in multiple locations)
- Updates the status bar with battery, volume, and clock information every second

## Wallpaper Location

The script will look for the wallpaper in these locations (in order):
1. `$DWM_DIR/wallpaper/drwp1.jpeg` (if `DWM_DIR` environment variable is set)
2. `~/.local/share/dwm/wallpaper/drwp1.jpeg`
3. `~/.dwm/wallpaper/drwp1.jpeg`
4. `/usr/local/share/dwm/wallpaper/drwp1.jpeg`

To use a custom location, either:
- Set the `DWM_DIR` environment variable to point to your dwm source directory
- Copy the `wallpaper` directory to one of the locations above

