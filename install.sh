#!/bin/bash

# Install everything and link the configs into place.
# Existing config files are adopted into the repo, so check `git diff` afterwards.

set -e

cd "$(dirname "$0")"

PACKAGES=(aerospace sketchybar borders ghostty zed starship zsh git claude)

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh"
  exit 1
fi

echo "Installing Homebrew packages..."
brew bundle --file=Brewfile

echo "Linking configs..."
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Library/Application Support/com.mitchellh.ghostty"
stow --adopt --target="$HOME" "${PACKAGES[@]}"

echo "Applying macOS settings..."
./macos/defaults.sh

echo "Starting services..."
brew services restart sketchybar
brew services restart borders
open -a AeroSpace

echo "Done. Grant AeroSpace Accessibility access when asked."
