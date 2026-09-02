-- Small quality-of-life plugins.

return {
	-- Type ( and get (), type " around a selection and it wraps it.
	-- Understands context, so it will not add a quote inside a word.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- Move between Neovim splits and tmux panes with the same Ctrl+h/j/k/l.
	--
	-- IMPORTANT: this only works because the tmux side is installed too - see
	-- the vim-tmux-navigator entry in tmux/.config/tmux/tmux.conf. Installing
	-- only one half is the usual reason these keys "stop working".
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
		},
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Window/pane left" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Window/pane below" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Window/pane above" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window/pane right" },
		},
	},

	-- Highlights TODO / FIXME / NOTE / HACK comments and makes them searchable.
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
		keys = {
			{ "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "TODO comments" },
		},
	},

	-- Comment or uncomment with gcc (line) and gc in visual mode.
	-- Knows JSX and embedded languages, where a plain // would be wrong.
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "VeryLazy",
		opts = { enable_autocmd = false },
		config = function(_, opts)
			require("ts_context_commentstring").setup(opts)
			vim.g.skip_ts_context_commentstring_module = true
		end,
	},
}
