#!/bin/bash

# macOS settings for an Omarchy style desktop.
# Safe to run more than once. Some changes need a log out to fully apply.

set -e

echo "Hiding the menu bar..."
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.controlcenter AutoHideMenuBarOption -int 0

echo "Hiding the Dock for good..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock launchanim -bool false

echo "Configuring Spaces and Mission Control for AeroSpace..."
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock showMissionControlGestureEnabled -bool false
defaults write com.apple.dock showAppExposeGestureEnabled -bool false

echo "Disabling Mission Control trackpad gestures..."
for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  defaults write "$domain" TrackpadThreeFingerVertSwipeGesture -int 0
  defaults write "$domain" TrackpadFourFingerVertSwipeGesture -int 0
  defaults write "$domain" TrackpadThreeFingerHorizSwipeGesture -int 0
  defaults write "$domain" TrackpadFourFingerHorizSwipeGesture -int 0
done
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerVertSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.fourFingerVertSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.fourFingerHorizSwipeGesture -int 0

echo "Disabling Mission Control keyboard shortcuts..."
# 32/34 Mission Control, 33/35 Application windows, 79 to 82 move a Space left or right
HOTKEYS="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
for id in 32 33 34 35 79 80 81 82; do
  /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:${id}:enabled false" "$HOTKEYS" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:${id}:enabled bool false" "$HOTKEYS"
done
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "Removing animations..."
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.finder DisableAllAnimations -bool true

echo "Speeding up key repeat..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Theming Helium with Osaka Jade..."
defaults write net.imput.helium BrowserThemeColor -string "#111c18"

killall Dock Finder SystemUIServer ControlCenter 2>/dev/null || true

echo "Done. Turn on Reduce Motion by hand in System Settings > Accessibility > Motion,"
echo "then log out and back in for the trackpad and key repeat changes."
