#!/bin/bash

# Recent macOS hides the SSID from scripts without location access,
# so this only shows whether Wi-Fi has an IP address.
DEVICE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"
IP="$(ipconfig getifaddr "$DEVICE" 2>/dev/null)"

if [ -n "$IP" ]; then
  sketchybar --set "$NAME" icon="󰖩" label.drawing=off
else
  sketchybar --set "$NAME" icon="󰖪" label.drawing=off
fi
