#!/bin/bash

# Pull the latest configs and apply them to this machine.
# Commit or discard local changes first, so app written settings don't slip into the merge.

set -e

cd "$(dirname "$0")"

source packages.sh

if [ -n "$(git status --porcelain)" ]; then
  echo "The repo has uncommitted changes. Commit or discard them first:"
  git status --short
  exit 1
fi

echo "Pulling..."
git pull --ff-only

echo "Linking configs..."
# herdr keeps logs, sessions and plugins.json next to its config, so link its files rather than the folder.
OTHER_PACKAGES=()
for PACKAGE in "${PACKAGES[@]}"; do
  [ "$PACKAGE" = herdr ] || OTHER_PACKAGES+=("$PACKAGE")
done
stow --restow --target="$HOME" "${OTHER_PACKAGES[@]}"
stow --restow --target="$HOME" --no-folding herdr

echo "Updating Homebrew packages..."
brew bundle --file=Brewfile

echo "Updating global Composer packages..."
COMPOSER_HOME="$HOME/.config/composer" composer global install

echo "Reloading herdr..."
herdr server reload-config >/dev/null 2>&1 || echo "herdr isn't running, it will load the config on next launch."

# PhpStorm overwrites its settings on exit, so only push while it's closed.
if pgrep -q -f "PhpStorm.*\.app/Contents/MacOS"; then
  echo "Skipped PhpStorm because it's running. Quit it and run ./phpstorm/sync.sh push."
else
  ./phpstorm/sync.sh push
fi

echo "Done."
