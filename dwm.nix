{ config, pkgs, lib, ... }:

let
  # Custom dwm with minimal keybinding changes
  customDwm = pkgs.dwm.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      # Ensure config.h exists from default
      if [ ! -f config.h ]; then
        cp config.def.h config.h
      fi

      # Change MODKEY to Mod4Mask (Meta/Windows key)
      substituteInPlace config.h \
        --replace '#define MODKEY Mod1Mask' '#define MODKEY Mod4Mask'

      # Change terminal to st
      sed -i 's|static const char \*termcmd\[\].*|static const char *termcmd[]  = { "st", NULL };|' config.h

      # Change dmenu keybind from mod+p to mod+d
      substituteInPlace config.h \
        --replace '{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },' \
                  '{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },'

      # Terminal on mod+Return
      substituteInPlace config.h \
        --replace '{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },' \
                  '{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },'

      # Quit on mod+Shift+Escape
      substituteInPlace config.h \
        --replace '{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },' \
                  '{ MODKEY|ShiftMask,             XK_Escape, quit,           {0} },'

      # --- Insert custom commands and keybindings ---
      # Commands (volume and wifi)
      sed -i '/static const char \*termcmd\[\]/a\
static const char *volup[]    = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };\
static const char *voldown[]  = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };\
static const char *volmute[]  = { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };\
static const char *wifitoggle[] = { "nmcli", "radio", "wifi", "toggle", NULL };' config.h

      # Keybindings: append inside keys[] array
      sed -i '/static Key keys\[\] = {/,/};/ s/};/    { MODKEY, XK_minus, spawn, {.v = voldown } },\
    { MODKEY, XK_equal, spawn, {.v = volup } },\
    { MODKEY, XK_m, spawn, {.v = volmute } },\
    { MODKEY, XK_w, spawn, {.v = wifitoggle } },\
};/' config.h

      # Remove coloring of bar when focused
      sed -i '/static const char \*colors\[\]\[/,/};/c\
static const char *colors[][3] = {\
       [SchemeNorm] = { "#c0c0c0", "#1c1c1c", "#1c1c1c" },\
       [SchemeSel]  = { "#c0c0c0", "#1c1c1c", "#1c1c1c" },\
};' config.h
    '';
  });
in
{
  services.xserver.windowManager.dwm = {
    enable = true;
    package = customDwm;
  };

  services.xserver.displayManager.sessionCommands = lib.mkIf (config.services.xserver.windowManager.dwm.enable) ''
    # Wait for DISPLAY
    while [ -z "$DISPLAY" ]; do sleep 0.1; done

    # Wallpaper
    if command -v feh >/dev/null 2>&1 && \
       [ -f /etc/nixos/nix/home/desktop_files/wallpapers/drwp1.jpeg ]; then
      feh --bg-scale /etc/nixos/nix/home/desktop_files/wallpapers/drwp1.jpeg &
    fi

    # Status bar loop: battery, Wi-Fi, volume, clock
    while true; do
      # Battery
      batt=""
      if [ -d /sys/class/power_supply/BAT0 ]; then
        cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        stat=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        symbol="⚡"
        [ "$stat" = "Charging" ] && symbol="🔌"
        [ "$stat" = "Discharging" ] && symbol="🔋"
        batt="$symbol $cap%"
      fi

      # Wi-Fi
      wifi=""
      if command -v nmcli >/dev/null 2>&1; then
        wifi_state=$(nmcli -t -f WIFI g)
        if [ "$wifi_state" = "enabled" ]; then
          ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes:' | cut -d':' -f2)
          [ -z "$ssid" ] && ssid="Disconnected"
          wifi="󰖩 $ssid"
        else
          wifi="󰖪 Off"
        fi
      fi

      # PulseAudio volume
      vol=""
      if command -v pactl >/dev/null 2>&1; then
        sink=$(pactl info | grep "Default Sink" | cut -d' ' -f3)
        if [ -n "$sink" ]; then
          mute=$(pactl get-sink-mute "$sink")
          if [[ "$mute" == *"yes"* ]]; then
            vol="󰖁 Muted"
          else
            pct=$(pactl get-sink-volume "$sink" | awk 'NR==1{print $5}')
            vol=" $pct"
          fi
        fi
      fi

      # Clock
      time="$(date '+%Y-%m-%d %H:%M:%S')"

      # Update dwm bar
      xsetroot -name "$batt   $wifi   $vol   $time"
      sleep 1
    done &
  '';

  environment.systemPackages = with pkgs; [
    customDwm
    st
    networkmanager
    pulseaudio
    feh
  ];
}

