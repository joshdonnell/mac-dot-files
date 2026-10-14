#!/bin/bash

# Open a new Ghostty window, launching Ghostty first if needed
if pgrep -xq ghostty; then
  osascript -e 'tell application "Ghostty" to new window' -e 'tell application "Ghostty" to activate'
else
  open -a Ghostty
fi
