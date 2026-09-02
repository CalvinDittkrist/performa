# performa

A terminal development setup for macOS: **Neovim**, **WezTerm**, **tmux** and **lazygit**,
themed consistently with Catppuccin Mocha and linked into place with GNU Stow.

Built to be *readable*. There is no distribution framework in the way — every file is
small, commented, and does one thing. If you want to change a shortcut you open
`keymaps.lua` and change the line.

---

## Install

```sh
git clone https://github.com/CalvinDittkrist/performa.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

`bootstrap.sh` installs everything from the `Brewfile`, does a dry run to check for
conflicts, and only then creates the symlinks. It never overwrites an existing file.

Afterwards:

1. Open a new terminal (or `exec zsh`) so `XDG_CONFIG_HOME` takes effect
2. Restart WezTerm to pick up the font and colours
3. In tmux press `Ctrl+Space` then `Shift+i` once to install the tmux plugins

Neovim installs its own plugins on first launch — just run `nvim` and wait.

---

## How it is wired up

Each top-level directory is a **stow package** that mirrors the path relative to `$HOME`:

```
performa/
├── Brewfile                 all dependencies, including the Nerd Font
├── bootstrap.sh             brew bundle + stow, idempotent
│
├── zsh/.zshenv                       -> ~/.zshenv
├── nvim/.config/nvim/                -> ~/.config/nvim
├── tmux/.config/tmux/tmux.conf       -> ~/.config/tmux/tmux.conf
├── wezterm/.config/wezterm/          -> ~/.config/wezterm
└── lazygit/.config/lazygit/          -> ~/.config/lazygit
```

`stow nvim` from this directory creates `~/.config/nvim` as a symlink back into the repo.
Editing `~/.config/nvim/init.lua` *is* editing this repo — `git status` picks it up.

Two consequences worth knowing:

- **`nvim/.config/nvim/lazy-lock.json` is committed on purpose.** lazy.nvim writes it
  through the symlink into the repo, which pins every plugin to an exact commit. A second
  machine gets byte-identical plugin versions.
- **tmux plugins live in `~/.local/share/tmux/plugins`, not next to `tmux.conf`.** The
  default location would clone plugin sources straight into this repo's history.
- **lazygit rewrites its own config** when its schema changes between releases. Because
  of the symlink that edit lands in this repo, so it shows up in `git status` — that is
  working as intended, just commit it.

### Why `zsh/.zshenv` exists

Exactly one line: `export XDG_CONFIG_HOME="$HOME/.config"`.

On macOS lazygit reads `~/Library/Application Support/lazygit` unless that variable is
set. `$HOME/.config` is the standard value anyway, so nothing else changes. Verify with:

```sh
lazygit --print-config-dir      # expect ~/.config/lazygit
```

---

## Where do I change what?

| I want to change… | Open |
| --- | --- |
| a keyboard shortcut | `nvim/.config/nvim/lua/config/keymaps.lua` |
| line numbers, tabs, search behaviour | `nvim/.config/nvim/lua/config/options.lua` |
| something that happens automatically | `nvim/.config/nvim/lua/config/autocmds.lua` |
| add / remove a Neovim plugin | a file in `nvim/.config/nvim/lua/plugins/` |
| add a language server | the `servers` list in `lua/plugins/lsp.lua` |
| which formatter runs on save | `lua/plugins/format.lua` |
| the colour scheme | `lua/plugins/colorscheme.lua` (+ the other three tools' configs) |
| terminal font, padding, opacity | `wezterm/.config/wezterm/wezterm.lua` |
| tmux prefix, splits, status bar | `tmux/.config/tmux/tmux.conf` |

### Adding a Neovim plugin

Create or edit a file under `lua/plugins/` and return a table:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",   -- when to load it
  opts = {},            -- passed to the plugin's setup()
}
```

Restart Neovim, or run `:Lazy sync`. Remove the entry and run `:Lazy clean` to uninstall.

---

## Cheat sheet

`<leader>` is the **Space** key. Press it and wait — which-key shows you every option.

### Neovim — files and search

| Keys | Does |
| --- | --- |
| `<Space><Space>` | find a file |
| `<Space>fg` | search text across the project |
| `<Space>fb` | switch between open files |
| `<Space>fr` | recently opened files |
| `<Space>fk` | search all shortcuts |
| `<Space>e` | toggle the file tree |
| `<Space>?` | shortcuts available right here |

### Neovim — code

| Keys | Does |
| --- | --- |
| `gd` | go to definition |
| `gr` | show all references |
| `K` | show documentation |
| `<Space>cr` | rename symbol everywhere |
| `<Space>ca` | code action / quick fix |
| `<Space>cf` | format now |
| `]d` / `[d` | next / previous problem |
| `<Space>ci` | LSP status (`:checkhealth vim.lsp`) |

### Neovim — git

| Keys | Does |
| --- | --- |
| `<Space>gg` | open lazygit |
| `]h` / `[h` | next / previous change |
| `<Space>gp` | preview this change |
| `<Space>gs` | stage this change |
| `<Space>gb` | who wrote this line |

### Neovim — editing

| Keys | Does |
| --- | --- |
| `jk` | leave insert mode |
| `<Esc>` | clear search highlight |
| `<Space>w` | save |
| `Shift+h` / `Shift+l` | previous / next file |
| `gcc` | comment out the line |
| `J` / `K` in visual mode | move the selection |
| `<CR>` in normal mode | grow selection along the syntax tree |

### tmux — prefix is `Ctrl+Space`

| Keys | Does |
| --- | --- |
| `prefix` `\|` | split left/right |
| `prefix` `-` | split top/bottom |
| `prefix` `c` | new window |
| `prefix` `1`…`9` | jump to window |
| `prefix` `d` | detach (session keeps running) |
| `prefix` `[` | scroll back, `v` select, `y` copy, `q` leave |
| `prefix` `r` | reload the config |
| `prefix` `Ctrl+l` | clear the screen |
| `Ctrl+h/j/k/l` | move between panes **and** Neovim splits |

`tmux a` reattaches to the last session.

### lazygit

| Keys | Does |
| --- | --- |
| `Space` | stage / unstage the selected file |
| `c` | commit |
| `P` / `p` | push / pull |
| `Tab` | next panel |
| `x` | menu of everything available here |
| `q` | quit |

---

## Troubleshooting

**Boxes or question marks instead of icons** — the Nerd Font is missing or WezTerm has
not been restarted. Check with:

```sh
wezterm ls-fonts --text "󰊕"
```

**lazygit ignores its config** — you are in a shell started before `~/.zshenv` existed.
Open a new terminal and re-check `lazygit --print-config-dir`.

**`Ctrl+h/j/k/l` does not move between tmux and Neovim** — vim-tmux-navigator has to be
installed on *both* sides. Run `prefix` `Shift+i` in tmux and `:Lazy sync` in Neovim.

**A language server is not attaching** — run `:checkhealth vim.lsp` in the affected file.
If the binary is missing, `:Mason` will install it.

**Is anything broken?** — `:checkhealth` is the place to look. A healthy install reports
no errors. Two warnings from `vim.pack` about an empty `site/pack/core` directory are
expected; Neovim creates that directory itself and then complains about it.

**Start over from scratch** — `stow -D <package>` removes the symlinks; deleting
`~/.local/share/nvim` resets all Neovim plugins.
