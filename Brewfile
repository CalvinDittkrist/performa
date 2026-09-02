# Every package this setup needs.
# Install / update:  brew bundle --file=Brewfile
# Check only:        brew bundle check --file=Brewfile

# --- Core tools ---
brew "neovim"   # editor
brew "tmux"     # terminal multiplexer (several panes/windows per terminal)
brew "lazygit"  # terminal UI for git
brew "stow"     # symlinks the configs from this repo into ~/

# --- Required by Neovim ---
brew "ripgrep"  # project-wide text search (Telescope's live grep depends on it)
brew "fd"       # fast file search (Telescope uses it when available)
brew "fzf"      # fuzzy finder, also handy straight from the shell

# --- Terminal + font ---
cask "wezterm"
# A Nerd Font is a regular font plus thousands of extra icon glyphs.
# Without it, Neovim and lazygit render empty boxes instead of symbols.
cask "font-jetbrains-mono-nerd-font"
