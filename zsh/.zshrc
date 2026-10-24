eval "$(starship init zsh)"

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Completions (Docker CLI and anything Homebrew adds)
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit && compinit

# nvm, from Homebrew or the install script
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Herd injected PHP binary.
export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP configuration.
export HERD_PHP_74_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/74/"
export HERD_PHP_80_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/80/"
export HERD_PHP_81_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/81/"
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"
export HERD_PHP_86_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/86"

# DBngin MySQL client (mysql/mysqldump for native tests)
export PATH="/Users/Shared/DBngin/mysql/8.0.33/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

alias pa="php artisan"
alias pest="./vendor/bin/pest --parallel"
alias phpstan="./vendor/bin/phpstan --memory-limit='2G'"
alias pamf="pa migrate:fresh --seed && pa dev:seed --fresh"

# Attach to the devbox herdr with its keybindings, since local custom commands (lazygit on prefix+d) aren't sent over --remote.
alias devbox="herdr --remote devbox@devbox --remote-keybindings server"

# Terminal tools
# ansi follows the Ghostty palette in both light and dark mode.
export BAT_THEME="ansi"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --cycle'

if [[ -t 0 && -t 1 ]] && command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

alias ls="eza"
alias ll="eza -la"
alias tree="eza --tree"
alias cat="bat"
