-- Interface: shortcut hints, status line, indent guides.

return {
	-- which-key: the single most useful plugin while you are still learning.
	-- Press <Space> and wait ~400ms: a popup lists every shortcut that starts
	-- with it, along with the descriptions from lua/config/keymaps.lua.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 400, -- matches timeoutlen in options.lua
			spec = {
				-- Names for the shortcut groups shown in the popup.
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>s", group = "Split" },
				{ "<leader>u", group = "UI / toggles" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Shortcuts for this file",
			},
		},
	},

	-- Status line at the bottom: mode, branch, file, diagnostics, position.
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "catppuccin",
				globalstatus = true, -- one status line for all splits, not one each
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_c = { { "filename", path = 1 } }, -- path relative to cwd
			},
		},
	},

	-- Faint vertical lines showing indent levels.
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "│" },
			scope = { enabled = false },
		},
	},
}
