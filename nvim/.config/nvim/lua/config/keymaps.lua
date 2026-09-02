-- Every shortcut that is not defined by a plugin lives here.
--
-- Reading a mapping:
--   vim.keymap.set(mode, keys, action, { desc = "..." })
--   mode "n" = normal, "i" = insert, "v" = visual, "t" = terminal
--
-- <leader> is the Space key (set in options.lua).
-- The `desc` texts are what which-key shows in its popup, so keep them short
-- and in plain language.

local map = vim.keymap.set

-- --- Basics ---------------------------------------------------------------

-- jk leaves insert mode without reaching for <Esc>.
map("i", "jk", "<Esc>", { desc = "Leave insert mode" })

-- <Esc> in normal mode clears the leftover search highlight.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Close window" })

-- --- Moving around --------------------------------------------------------

-- Move by visible line when a line is soft-wrapped, by real line otherwise.
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep the cursor centred while paging and while jumping between search hits,
-- so you never lose your place.
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Ctrl+h/j/k/l moves between windows. Inside tmux this also jumps into
-- neighbouring tmux panes - that is handled by vim-tmux-navigator, which
-- overrides these four mappings when it loads (see lua/plugins/editing.lua).
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize windows with the arrow keys.
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Grow window" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shrink window" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Narrow window" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Widen window" })

-- --- Buffers (open files) -------------------------------------------------

map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- --- Windows --------------------------------------------------------------

map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalise splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- --- Editing --------------------------------------------------------------

-- Move the selected block up/down and re-indent it.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in visual mode after indenting, so you can repeat < or > right away.
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- Paste over a selection without losing what you had yanked.
map("v", "p", '"_dP', { desc = "Paste without yanking selection" })

-- --- German keyboard: bracket pairs ---------------------------------------
--
-- Vim navigates in pairs: [d / ]d jumps between problems, [h / ]h between git
-- changes, and plugins keep adding more. On a German layout [ and ] are Alt+5
-- and Alt+6, which is unusable for something you press this often.
--
-- oe and ae sit exactly where [ and ] are on a US keyboard, so this maps them
-- through. Everything of the form [x / ]x - including pairs added later by a
-- plugin - works as oex / aex without needing its own mapping.
--
-- remap = true is what makes that work: it lets the result be looked up again
-- rather than being taken literally.
map("n", "ö", "[", { remap = true, desc = "Same as [" })
map("n", "ä", "]", { remap = true, desc = "Same as ]" })
map("x", "ö", "[", { remap = true, desc = "Same as [" })
map("x", "ä", "]", { remap = true, desc = "Same as ]" })

-- --- Diagnostics (errors and warnings) ------------------------------------
-- Reachable as öd / äd too, via the mapping above.

map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous problem" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next problem" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show problem details" })

-- --- Terminal -------------------------------------------------------------

-- <Esc><Esc> leaves the terminal's insert mode (otherwise <Esc> goes to the shell).
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
