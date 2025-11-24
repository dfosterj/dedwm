#!/bin/sh

# Status bar loop: battery, volume, clock
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

	# PulseAudio volume
	vol=""
	if command -v pactl >/dev/null 2>&1; then
		sink=$(pactl info | grep "Default Sink" | cut -d' ' -f3)
		if [ -n "$sink" ]; then
			mute=$(pactl get-sink-mute "$sink")
			if [[ "$mute" == *"yes"* ]]; then
				vol="🔇 Muted"
			else
				pct=$(pactl get-sink-volume "$sink" | awk 'NR==1{print $5}')
				vol="🔊 $pct"
			fi
		fi
	fi

	# Clock
	time="$(date '+%Y-%m-%d %H:%M:%S')"

	# Update dwm bar
	xsetroot -name "$batt   $vol   $time"
	sleep 1
done

