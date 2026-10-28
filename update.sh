#!/bin/bash

# Pull the latest configs and apply them to this machine.
# Commit or discard local changes first, so app written settings don't slip into the merge.

set -e

cd "$(dirname "$0")"

if [ -n "$(git status --porcelain)" ]; then
  echo "The repo has uncommitted changes. Commit or discard them first:"
  git status --short
  exit 1
fi

echo "Pulling..."
git pull --ff-only

# Sourced after the pull, so a package removed upstream isn't restowed from the old list.
source packages.sh

echo "Linking configs..."
# herdr keeps logs, sessions and plugins.json next to its config, so link its files rather than the folder.
OTHER_PACKAGES=()
for PACKAGE in "${PACKAGES[@]}"; do
  [ "$PACKAGE" = herdr ] || OTHER_PACKAGES+=("$PACKAGE")
done
stow --restow --target="$HOME" "${OTHER_PACKAGES[@]}"
stow --restow --target="$HOME" --no-folding herdr
# A package dropped from packages.sh leaves its links behind, pointing at files the pull removed.
# macOS denies access to some Application Support folders, which makes find fail and set -e stop the script.
find "$HOME/.config" "$HOME/Library/Application Support" -maxdepth 3 -type l -lname '*mac-dot-files/*' ! -exec test -e {} \; -print -delete 2>/dev/null || true

echo "Updating Homebrew packages..."
brew bundle --file=Brewfile

echo "Updating global Composer packages..."
COMPOSER_HOME="$HOME/.config/composer" composer global install

echo "Updating herdr plugins..."
# herdr-ade replaces herdr-workspace-setup, and with both installed a new worktree is set up twice.
if herdr plugin list 2>/dev/null | grep -q "shire-studio.workspaces "; then
  herdr plugin uninstall shire-studio.workspaces || true
fi
if ! herdr plugin list 2>/dev/null | grep -q "shire-studio.ade "; then
  herdr plugin install shire-studio/herdr-ade --yes || true
fi

echo "Reloading herdr..."
herdr server reload-config >/dev/null 2>&1 || echo "herdr isn't running, it will load the config on next launch."

# PhpStorm overwrites its settings on exit, so only push while it's closed.
if pgrep -q -f "PhpStorm.*\.app/Contents/MacOS"; then
  echo "Skipped PhpStorm because it's running. Quit it and run ./phpstorm/sync.sh push."
else
  ./phpstorm/sync.sh push
fi

echo "Done."
