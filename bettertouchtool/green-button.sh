#!/bin/bash

# Makes the green window button use AeroSpace fullscreen (the same as Cmd+Ctrl+F)
# instead of macOS native fullscreen, so the window stays in its workspace.
# Safe to run more than once: each trigger has a fixed UUID and is deleted before being added again.
# add_new_trigger is used because update_trigger saves new triggers without attaching them
# to the Global app, so they never fire.

set -e

# 623 is the green button on windows that support fullscreen, 615 on windows that only zoom
add_trigger() {
  local uuid="$1" type="$2"
  local json
  json=$(cat <<EOF
{
  "BTTUUID": "$uuid",
  "BTTTriggerType": $type,
  "BTTTriggerClass": "BTTTriggerTypeOtherTriggers",
  "BTTEnabled": 1,
  "BTTActionsToExecute": [
    { "BTTPredefinedActionType": 204, "BTTOrder": 0 },
    {
      "BTTPredefinedActionType": 206,
      "BTTOrder": 1,
      "BTTShellTaskActionScript": "/opt/homebrew/bin/aerospace fullscreen --no-outer-gaps",
      "BTTShellTaskActionConfig": "/bin/bash:::-c:::-:::"
    }
  ]
}
EOF
)
  osascript - "$uuid" "$json" <<'APPLESCRIPT'
on run argv
  tell application "BetterTouchTool"
    delete_trigger (item 1 of argv)
    add_new_trigger (item 2 of argv)
  end tell
end run
APPLESCRIPT
}

add_trigger "6B1F2C3A-0623-4A10-9E57-1D2A0E5F0623" 623
add_trigger "6B1F2C3A-0615-4A10-9E57-1D2A0E5F0615" 615
