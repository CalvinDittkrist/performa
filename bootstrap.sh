#!/usr/bin/env bash
#
# Sets this configuration up on a Mac.
# Usage:  ./bootstrap.sh
#
# Idempotent: running it more than once is harmless.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh nvim tmux wezterm lazygit)

# Only colourise when we are actually attached to a terminal.
if [ -t 1 ]; then
  BOLD=$'\033[1m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
  BOLD=""; GREEN=""; YELLOW=""; RED=""; RESET=""
fi

step() { printf '\n%s==> %s%s\n' "$BOLD" "$1" "$RESET"; }
ok()   { printf '%s  ok%s  %s\n' "$GREEN" "$RESET" "$1"; }
warn() { printf '%s  !!%s  %s\n' "$YELLOW" "$RESET" "$1"; }
die()  { printf '\n%sError:%s %s\n' "$RED" "$RESET" "$1" >&2; exit 1; }

# ---------------------------------------------------------------------------
step "Checking prerequisites"

command -v brew >/dev/null || die "Homebrew is not installed. See https://brew.sh"
ok "Homebrew found"

# ---------------------------------------------------------------------------
step "Installing packages (Brewfile)"

brew bundle --file="$DOTFILES_DIR/Brewfile"
ok "all Brewfile packages present"

command -v stow >/dev/null || die "stow is missing despite the Brewfile - run 'brew install stow' manually."

# ---------------------------------------------------------------------------
step "Dry run: checking for conflicts (changes nothing yet)"

conflicts=0
for pkg in "${PACKAGES[@]}"; do
  dry_output="$(stow --no --verbose --dir="$DOTFILES_DIR" --target="$HOME" "$pkg" 2>&1 || true)"
  if printf '%s' "$dry_output" | grep -q 'existing target'; then
    warn "conflict in package '$pkg'"
    printf '%s' "$dry_output" | grep 'existing target' | sed 's/^/       /'
    conflicts=1
  else
    ok "$pkg"
  fi
done

if [ "$conflicts" -ne 0 ]; then
  cat <<'EOF'

Files already exist at those target paths and did not come from this repo.
stow refuses to overwrite them, which is deliberate.

Two ways forward:
  1. Back up and remove the listed files, then re-run ./bootstrap.sh
  2. Adopt them: 'stow --adopt <package>' moves the existing file INTO THE REPO
     (overwriting the repo's version!). Always inspect 'git diff' afterwards.
EOF
  die "Aborted because of conflicts - nothing was changed."
fi

# ---------------------------------------------------------------------------
step "Linking configs"

for pkg in "${PACKAGES[@]}"; do
  stow --restow --dir="$DOTFILES_DIR" --target="$HOME" "$pkg"
  ok "$pkg -> ~/"
done

# ---------------------------------------------------------------------------
step "Done"

cat <<EOF

Three things left to do by hand:

  1. ${BOLD}Open a new terminal${RESET} (or run 'exec zsh') so XDG_CONFIG_HOME takes effect.
     Check with:  lazygit --print-config-dir
     Expected:    $HOME/.config/lazygit

  2. ${BOLD}Restart WezTerm${RESET} so the font and colours are picked up.

  3. ${BOLD}Start tmux${RESET} and press  Ctrl+Space  then  Shift+i  once.
     That installs the tmux plugins (takes a few seconds).

  Neovim installs its plugins on first launch automatically - just run 'nvim'
  and wait a moment.

EOF
