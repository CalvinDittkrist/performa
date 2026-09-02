-- Colour scheme: Catppuccin Mocha.
--
-- The same theme is configured for WezTerm, tmux and lazygit, so the whole
-- terminal looks like one piece.

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,   -- the theme must load immediately, not on demand
		priority = 1000, -- ... and before every other plugin
		opts = {
			flavour = "mocha", -- latte (light) | frappe | macchiato | mocha
			transparent_background = false,
			integrations = {
				blink_cmp = true,
				gitsigns = true,
				neotree = true,
				telescope = true,
				treesitter = true,
				which_key = true,
				native_lsp = { enabled = true },
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
