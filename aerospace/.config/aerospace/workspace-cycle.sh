#!/bin/bash

# Go to the next or previous workspace that has windows, wrapping around,
# like Omarchy's Super+Tab and the trackpad swipe.
# Usage: workspace-cycle.sh next|prev
FOCUSED="$(aerospace list-workspaces --focused)"
WORKSPACES="$( (aerospace list-workspaces --monitor focused --empty no; echo "$FOCUSED") | sort -n -u)"

if [ "$1" = "prev" ]; then
  WORKSPACES="$(echo "$WORKSPACES" | sort -n -r)"
fi

TARGET="$(echo "$WORKSPACES" | awk -v current="$FOCUSED" 'NR == 1 { first = $0 } found { print; exit } $0 == current { found = 1 } END { if (!found || NR == 1) print first }' | head -1)"
[ -z "$TARGET" ] && TARGET="$(echo "$WORKSPACES" | head -1)"

aerospace workspace "$TARGET"
