#!/bin/bash

# Install everything and link the configs into place.
# Existing config files are adopted into the repo, so check `git diff` afterwards.

set -e

cd "$(dirname "$0")"

PACKAGES=(aerospace aerospace-swipe sketchybar borders ghostty zed starship zsh git claude)

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh"
  exit 1
fi

echo "Installing Homebrew packages..."
brew bundle --file=Brewfile

echo "Linking configs..."
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Library/Application Support/com.mitchellh.ghostty"
stow --adopt --target="$HOME" "${PACKAGES[@]}"

echo "Installing trackpad swipes for AeroSpace..."
SWIPE_DIR="$HOME/.local/share/aerospace-swipe"
if [ ! -d "$SWIPE_DIR" ]; then
  git clone https://github.com/acsandmann/aerospace-swipe "$SWIPE_DIR"
  make -C "$SWIPE_DIR" install
fi

echo "Applying macOS settings..."
./macos/defaults.sh

echo "Starting services..."
brew services restart sketchybar
sleep 1 && sketchybar --reload
brew services restart borders
open -a AeroSpace

echo "Pointing the green window button at AeroSpace fullscreen..."
open -a BetterTouchTool
sleep 5
./bettertouchtool/green-button.sh

echo "Done. Grant AeroSpace, AerospaceSwipe and BetterTouchTool Accessibility access when asked."
