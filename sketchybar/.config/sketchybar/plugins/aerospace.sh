#!/bin/bash

# $1 is the workspace this item represents
SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
WINDOWS="$(aerospace list-windows --workspace "$SID" --count 2>/dev/null)"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" drawing=on icon.highlight=on
elif [ "$SID" -le 5 ] || [ "${WINDOWS:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on icon.highlight=off
else
  sketchybar --set "$NAME" drawing=off
fi
