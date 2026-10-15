#!/bin/bash

# Copies PhpStorm settings between this repo and the newest PhpStorm config folder.
#   ./phpstorm/sync.sh pull   copy the IDE's settings into the repo
#   ./phpstorm/sync.sh push   copy the repo's settings into the IDE (quit PhpStorm first)
#
# PhpStorm replaces files when it saves them, which would break Stow symlinks,
# so these files are copied instead. Only the files below are synced, which keeps
# the license key, recent projects, SSH configs and Toolbox tokens out of the repo.

set -e

cd "$(dirname "$0")"

FILES=(
  codestyles
  colors
  keymaps
  disabled_plugins.txt
  options/mac/keymap.xml
  options/code.style.schemes
  options/colors.scheme.xml
  options/console-font.xml
  options/editor-font.xml
  options/editor.xml
  options/filetypes.xml
  options/find.xml
  options/gutter.xml
  options/ide.general.xml
  options/keymapFlags.xml
  options/laf.xml
  options/php.xml
  options/project.default.xml
  options/projectView.xml
  options/terminal-font.xml
  options/ui.lnf.xml
)

IDE_DIR=$(ls -d "$HOME/Library/Application Support/JetBrains/PhpStorm20"* 2>/dev/null | sort -V | tail -1)

if [ -z "$IDE_DIR" ]; then
  echo "No PhpStorm config folder found. Open PhpStorm once first."
  exit 1
fi

case "$1" in
  pull)
    for file in "${FILES[@]}"; do
      [ -e "$IDE_DIR/$file" ] || continue
      mkdir -p "settings/$(dirname "$file")"
      rm -rf "settings/$file"
      cp -R "$IDE_DIR/$file" "settings/$file"
    done
    ls "$IDE_DIR/plugins" > plugins.txt
    echo "Pulled settings from $IDE_DIR"
    ;;
  push)
    if pgrep -xq phpstorm; then
      echo "Quit PhpStorm first, it overwrites its settings on exit."
      exit 1
    fi
    for file in "${FILES[@]}"; do
      [ -e "settings/$file" ] || continue
      mkdir -p "$IDE_DIR/$(dirname "$file")"
      rm -rf "$IDE_DIR/$file"
      cp -R "settings/$file" "$IDE_DIR/$file"
    done
    echo "Pushed settings to $IDE_DIR. Install the plugins in plugins.txt if any are missing."
    ;;
  *)
    echo "Usage: $0 pull|push"
    exit 1
    ;;
esac
