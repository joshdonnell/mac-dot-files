
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"



# Q pre block. Keep at the top of this file.
export PATH=~/.composer/vendor/bin:$PATH
export NVM_DIR="$HOME/.nvm"
  . "/opt/homebrew/opt/nvm/nvm.sh"

eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/Users/josh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# Q post block. Keep at the bottom of this file.

# Herd injected PHP binary.
export PATH="/Users/josh/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/84/"


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/82/"


# Herd injected PHP 8.0 configuration.
export HERD_PHP_80_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/80/"


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/74/"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/josh/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions


# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/85/"
# Herd injected PHP 8.1 configuration.
export HERD_PHP_81_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/81/"

alias pa="php artisan"
alias pest="./vendor/bin/pest --parallel"
alias phpstan="./vendor/bin/phpstan --memory-limit='2G'"


# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/85/"

# bun completions
[ -s "/Users/josh/.bun/_bun" ] && source "/Users/josh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"


# Herd injected PHP 8.6 configuration.
export HERD_PHP_86_INI_SCAN_DIR="/Users/josh/Library/Application Support/Herd/config/php/86"
export PATH="$HOME/.local/bin:$PATH"

# Lerd
export PATH="/Users/josh/.local/share/lerd/bin:$PATH"

# Lerd completions
fpath=(/Users/josh/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
