#!/bin/bash

# Focus an app's window on any workspace, or launch it if it has none.
# Usage: app.sh <bundle-id>
BUNDLE_ID="$1"
WINDOW_ID="$(aerospace list-windows --monitor all --app-bundle-id "$BUNDLE_ID" --format '%{window-id}' | head -1)"

if [ -n "$WINDOW_ID" ]; then
  aerospace focus --window-id "$WINDOW_ID"
else
  open -b "$BUNDLE_ID"
fi
