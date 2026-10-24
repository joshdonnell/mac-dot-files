#!/bin/bash

# Install everything and link the configs into place.
# Existing config files are adopted into the repo, so check `git diff` afterwards.

set -e

cd "$(dirname "$0")"

source packages.sh

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh"
  exit 1
fi

echo "Installing Homebrew packages..."
brew bundle --file=Brewfile

echo "Linking configs..."
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Library/Application Support/com.mitchellh.ghostty" "$HOME/Library/Application Support/lazygit"
stow --adopt --target="$HOME" "${PACKAGES[@]}"

echo "Installing the Laravel language server..."
COMPOSER_HOME="$HOME/.config/composer" composer global install

echo "Setting up herdr..."
herdr integration install claude
herdr integration install codex
herdr integration install opencode

echo "Installing Claude plugins..."
# Marketplaces are also declared in claude/.claude/settings.json, so Claude installs missing plugins on start.
# Installing them here means they work in the first session too.
for marketplace in pbakaus/impeccable jarrodwatts/claude-hud laravel/agent-skills vercel-labs/agent-browser; do
  claude plugin marketplace add "$marketplace" || true
done
for plugin in \
  mattpocock-skills@claude-plugins-official superpowers@claude-plugins-official \
  frontend-design@claude-plugins-official stripe@claude-plugins-official swift-lsp@claude-plugins-official \
  impeccable@impeccable claude-hud@claude-hud laravel@laravel agent-browser@agent-browser; do
  claude plugin install "$plugin"
done

echo "Done."
