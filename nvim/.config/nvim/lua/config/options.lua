-- Editor behaviour.
--
-- Every setting is `vim.opt.<name>`. To look one up:  :help 'name'
-- (with the quotes, e.g. :help 'number')

local opt = vim.opt

-- The leader key is the prefix for custom shortcuts. Space is easy to reach with
-- either thumb. This must be set before plugins load, which is why it also lives
-- in keymaps.lua's sibling position - see lua/config/lazy.lua.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- --- Line numbers ---------------------------------------------------------
opt.number = true         -- absolute number on the current line
opt.relativenumber = true -- relative numbers elsewhere, so 5j / 3k are easy to aim
opt.cursorline = true     -- highlight the row the cursor is on
opt.signcolumn = "yes"    -- always reserve the left gutter, so text never jumps

-- --- Indentation ----------------------------------------------------------
opt.expandtab = true  -- insert spaces, never literal tab characters
opt.shiftwidth = 2    -- width of one indent level
opt.tabstop = 2       -- how wide an existing tab character looks
opt.softtabstop = 2
opt.smartindent = true

-- --- Search ---------------------------------------------------------------
opt.ignorecase = true -- searching for "todo" also finds "TODO" ...
opt.smartcase = true  -- ... unless you type a capital letter yourself
opt.hlsearch = true   -- highlight all matches (<Esc> clears it, see keymaps.lua)
opt.incsearch = true  -- jump along while typing the search

-- --- Splits ---------------------------------------------------------------
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below

-- --- Editing --------------------------------------------------------------
opt.wrap = false          -- no soft wrapping; long lines scroll sideways
opt.scrolloff = 8         -- keep 8 lines of context above/below the cursor
opt.sidescrolloff = 8
opt.mouse = "a"           -- mouse works in all modes
opt.clipboard = "unnamedplus" -- yank/paste uses the macOS system clipboard
opt.undofile = true       -- persist undo history across restarts
opt.swapfile = false      -- undofile + frequent commits make swap files noise
opt.confirm = true        -- ask to save instead of refusing to quit

-- --- Feedback -------------------------------------------------------------
opt.updatetime = 250  -- how long to idle before firing CursorHold (gitsigns, LSP)
opt.timeoutlen = 400  -- how long to wait for the rest of a mapping (which-key popup)
opt.termguicolors = true -- 24-bit colour, required by the theme
opt.showmode = false  -- lualine already shows the mode
opt.inccommand = "split" -- live preview of :substitute results

-- Show otherwise invisible characters, so stray tabs and trailing spaces stand out.
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
