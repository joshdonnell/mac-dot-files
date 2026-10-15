#!/bin/bash

# Build and install DwindleSpace, a fork of AeroSpace that adds Omarchy style
# dwindle tiling (https://github.com/imafukka/DwindleSpace).
# Run it again to update: it pulls the latest commits and rebuilds.
#
# The build is ad-hoc signed, so macOS asks for Accessibility access again after
# every rebuild. Remove the old AeroSpace entry in System Settings > Privacy &
# Security > Accessibility and allow the new one.
#
# To go back to stock AeroSpace: brew install --cask aerospace, then remove
# window-insertion from aerospace.toml.

set -e

SRC="$HOME/src/DwindleSpace"
export PATH="/opt/homebrew/bin:$PATH" # generate.sh needs Homebrew's bash 5

if [ -d "$SRC" ]; then
  git -C "$SRC" pull --ff-only
else
  git clone https://github.com/imafukka/DwindleSpace "$SRC"
fi
cd "$SRC"

echo "Building DwindleSpace..."
bash ./generate.sh --build-version "$(git describe --tags --abbrev=0)-dwindle" --codesign-identity "-" --generate-git-hash
swift build -c release --arch arm64 --product aerospace
(cd xcode && xcrun xcodebuild clean build -scheme AeroSpace -destination "generic/platform=macOS" \
  -configuration Release -derivedDataPath .xcode-build > ../xcodebuild.log 2>&1) \
  || { echo "xcodebuild failed, see $SRC/xcodebuild.log"; exit 1; }

rm -rf .release && mkdir .release
cp -R xcode/.xcode-build/Build/Products/Release/AeroSpace.app .release/
cp .build/out/Products/Release/aerospace .release/
codesign -s - -f .release/aerospace
git checkout -- Sources/Common xcode/AeroSpace.xcodeproj # undo generate.sh's changes so pulls stay clean

echo "Installing..."
osascript -e 'quit app "AeroSpace"' 2>/dev/null || true
sleep 2
rm -rf /Applications/AeroSpace.app
cp -R .release/AeroSpace.app /Applications/
ln -sf "$SRC/.release/aerospace" /opt/homebrew/bin/aerospace
open /Applications/AeroSpace.app

echo "Done. Allow AeroSpace in Accessibility if macOS asks."
