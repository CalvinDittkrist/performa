-- Telescope: the fuzzy finder. Search files, text, buffers, help - everything.
--
-- Inside the picker:
--   type to filter        <C-j>/<C-k> or arrows to move
--   <CR> open             <C-v> open in a vertical split
--   <C-t> open in a tab   <Esc> close
--
-- Live grep needs ripgrep, file search prefers fd - both come from the Brewfile.

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			-- Native C sorter: noticeably faster in large repos.
			-- Needs `make`, which macOS provides via the Command Line Tools.
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Text in project" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help pages" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Shortcuts" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Problems" },
		{ "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Word under cursor" },
		-- <leader><leader> is the one to remember: it opens the file picker.
		{ "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find file" },
	},
	opts = {
		defaults = {
			path_display = { "truncate" },
			-- Preview on the right, list on the left.
			layout_strategy = "horizontal",
			layout_config = { prompt_position = "top", preview_width = 0.55 },
			sorting_strategy = "ascending",
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["<Esc>"] = "close", -- close straight from insert mode
				},
			},
		},
		pickers = {
			find_files = {
				hidden = true, -- include dotfiles ...
				file_ignore_patterns = { "^%.git/" }, -- ... but not .git internals
			},
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		pcall(telescope.load_extension, "fzf")
	end,
}
