#!/bin/bash

# macOS settings for the Osaka Jade theme.
# Safe to run more than once.

set -e

echo "Theming Helium with Osaka Jade..."
defaults write net.imput.helium BrowserThemeColor -string "#111c18"

echo "Done. Restart Helium to see the new colour."
