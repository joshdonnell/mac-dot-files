eval "$(starship init zsh)"

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Completions (Docker CLI and anything Homebrew adds)
# Homebrew's dir is added here too, not only via brew shellenv in .zprofile, so login and
# non-login shells see the same fpath. Otherwise each switch between them rebuilds the dump.
typeset -U fpath
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)

# Run the full compinit (security audit + rebuild check) at most once a day, use the cached dump otherwise.
autoload -Uz compinit
() {
  setopt local_options extended_glob
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}

# fnm (Node version manager). --use-on-cd switches version when entering a folder with .nvmrc or .node-version.
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

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

# DBngin MySQL client (mysql/mysqldump for native tests)
export PATH="/Users/Shared/DBngin/mysql/8.0.33/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

alias pa="php artisan"
alias pest="./vendor/bin/pest --parallel"
alias phpstan="./vendor/bin/phpstan --memory-limit='2G'"
alias pamf="pa migrate:fresh --seed && pa dev:seed --fresh"

# Attach to the devbox herdr with its keybindings, since local custom commands (the herdr-ade keys) aren't sent over --remote.
alias devbox="herdr --remote devbox@devbox --remote-keybindings server"

# Fetch a GitHub branch and open it as a Herdr worktree. Run from the repo: hwt <branch>
hwt() {
  local branch="${1:-}"
  if [[ -z "$branch" ]]; then
    echo "usage: hwt <branch>" >&2
    return 1
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "hwt: not inside a git repository" >&2
    return 1
  fi

  local main
  main="$(git worktree list --porcelain | awk 'NR==1 && $1=="worktree" { print substr($0, 10); exit }')"
  if [[ -z "$main" ]]; then
    echo "hwt: could not find the main worktree" >&2
    return 1
  fi

  # Creates the local branch from origin when it is missing, and fast-forwards it when it already exists.
  if ! git -C "$main" fetch origin "${branch}:${branch}"; then
    return 1
  fi

  herdr worktree create --cwd "$main" --branch "$branch" --focus
}

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


# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/jdonnell/Library/Application Support/Herd/config/php/85"


# Herd injected PHP 8.6 configuration.
export HERD_PHP_86_INI_SCAN_DIR="/Users/jdonnell/Library/Application Support/Herd/config/php/86"


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/jdonnell/Library/Application Support/Herd/config/php/84"
