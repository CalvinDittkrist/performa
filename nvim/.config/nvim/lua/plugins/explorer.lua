-- File tree sidebar.
--
--   <leader>e   toggle the tree
--
-- Inside the tree:
--   <CR> open      a add        d delete     r rename
--   c copy         x cut        p paste      H toggle hidden files
--   ? full help

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "File tree" },
		{ "<leader>fe", "<cmd>Neotree reveal<CR>", desc = "Reveal current file in tree" },
	},
	opts = {
		close_if_last_window = true, -- do not leave a lone sidebar behind
		popup_border_style = "rounded",
		filesystem = {
			follow_current_file = { enabled = true }, -- highlight the file you are editing
			use_libuv_file_watcher = true, -- pick up changes made outside Neovim
			filtered_items = {
				hide_dotfiles = false, -- this is a dotfiles repo, after all
				hide_gitignored = true,
				hide_by_name = { ".git", ".DS_Store", "node_modules" },
			},
		},
		window = {
			width = 32,
			mappings = {
				["<Esc>"] = "close_window",
			},
		},
		default_component_configs = {
			indent = { with_expanders = true },
		},
	},
}
