#!/bin/bash

# Install everything and link the configs into place.
# Existing config files are adopted into the repo, so check `git diff` afterwards.

set -e

cd "$(dirname "$0")"

PACKAGES=(ghostty zed starship zsh git claude nvim lazygit herdr composer)

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
claude plugin marketplace add pbakaus/impeccable || true
claude plugin install mattpocock-skills@claude-plugins-official
claude plugin install impeccable@impeccable

echo "Done."
