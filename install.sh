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

echo "Setting up Node..."
# Only when fnm has no default yet, so an existing Node and its global npm packages are left alone.
if ! fnm exec --using=default node -v >/dev/null 2>&1; then
  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"
fi

echo "Linking configs..."
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Library/Application Support/com.mitchellh.ghostty"
# herdr keeps logs, sessions and plugins.json next to its config, so link its files rather than the folder.
OTHER_PACKAGES=()
for PACKAGE in "${PACKAGES[@]}"; do
  [ "$PACKAGE" = herdr ] || OTHER_PACKAGES+=("$PACKAGE")
done
stow --adopt --target="$HOME" "${OTHER_PACKAGES[@]}"
stow --adopt --target="$HOME" --no-folding herdr

echo "Installing the Laravel language server..."
COMPOSER_HOME="$HOME/.config/composer" composer global install

echo "Setting up herdr..."
herdr integration install claude
herdr integration install codex
herdr integration install opencode
# herdr-ade: the workspace status rows and the prefix+d, prefix+a and prefix+f keys in herdr/.config/herdr/config.toml. Builds with cargo.
herdr plugin install shire-studio/herdr-ade --yes || true

echo "Installing Claude plugins..."
# Marketplaces are also declared in claude/.claude/settings.json, so Claude installs missing plugins on start.
# Installing them here means they work in the first session too.
for marketplace in pbakaus/impeccable jarrodwatts/claude-hud laravel/agent-skills vercel-labs/agent-browser kaankiziltug/logo-design-skill; do
  claude plugin marketplace add "$marketplace" || true
done
for plugin in \
  mattpocock-skills@claude-plugins-official superpowers@claude-plugins-official \
  frontend-design@claude-plugins-official stripe@claude-plugins-official swift-lsp@claude-plugins-official \
  impeccable@impeccable claude-hud@claude-hud laravel@laravel agent-browser@agent-browser \
  logo-design@logo-design-skill; do
  claude plugin install "$plugin"
done

echo "Turning off the macOS emoji picker shortcuts..."
# Raycast's emoji search on Hyper+Shift+E replaces them (see Keyboard shortcuts in the README).
# The Globe key does nothing instead of opening Emoji & Symbols.
defaults write com.apple.HIToolbox AppleFnUsageType -int 0
# Ctrl+Cmd+Space can't be removed, so the menu item moves to Cmd+Ctrl+Opt+Shift+F19, which no keyboard sends.
defaults write -g NSUserKeyEquivalents -dict-add "Emoji & Symbols" '@^~$\Uf71c'

echo "Done."
