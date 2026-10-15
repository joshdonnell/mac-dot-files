#!/bin/bash

# $1 is the workspace this item represents
SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
WINDOWS="$(aerospace list-windows --workspace "$SID" --count 2>/dev/null)"

# Draw the item on the bar of the display AeroSpace has the workspace on.
# AeroSpace's NSScreen index matches SketchyBar's display numbering.
DISPLAY_ID="$(aerospace list-workspaces --all --format '%{workspace} %{monitor-appkit-nsscreen-screens-id}' | awk -v s="$SID" '$1 == s { print $2 }')"
VISIBLE="$(aerospace list-workspaces --monitor all --visible)"
# With an external display, 6 to 9 sit on their own display, so always show them there
OWN_DISPLAY=0
if [ "$SID" -gt 5 ] && [ "$(aerospace list-monitors --count)" -gt 1 ]; then
  OWN_DISPLAY=1
fi

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" display="${DISPLAY_ID:-1}" drawing=on icon.highlight=on
elif [ "$SID" -le 5 ] || [ "$OWN_DISPLAY" = 1 ] || [ "${WINDOWS:-0}" -gt 0 ] || grep -qx "$SID" <<<"$VISIBLE"; then
  sketchybar --set "$NAME" display="${DISPLAY_ID:-1}" drawing=on icon.highlight=off
else
  sketchybar --set "$NAME" drawing=off
fi
