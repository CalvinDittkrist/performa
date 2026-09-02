-- Treesitter parses your code into a real syntax tree.
--
-- That gives much more accurate highlighting than regex, plus structure-aware
-- selection and motions.
--
-- Add a language:  put it in `ensure_installed` below, or run :TSInstall <lang>

return {
	"nvim-treesitter/nvim-treesitter",
	-- Pinned to master on purpose. The repo's default branch ("main") is a
	-- ground-up rewrite with a different, still-moving API and far less
	-- documentation out there. master is stable and matches every tutorial you
	-- will find while learning.
	branch = "master",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			-- config + shell
			"lua",
			"luadoc",
			"vim",
			"vimdoc",
			"bash",
			-- web / TypeScript projects
			"javascript",
			"typescript",
			"tsx",
			"html",
			"css",
			"json",
			"jsonc",
			-- Python
			"python",
			-- IoT / embedded
			"c",
			"cpp",
			-- data + infra
			"yaml",
			"toml",
			"sql",
			"dockerfile",
			-- docs
			"markdown",
			"markdown_inline",
			"gitcommit",
			"diff",
		},
		auto_install = true, -- fetch a parser automatically for unlisted file types
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				-- Grow the selection along the syntax tree: press <CR> repeatedly to
				-- go from word -> expression -> statement -> function.
				init_selection = "<CR>",
				node_incremental = "<CR>",
				node_decremental = "<BS>",
				scope_incremental = false,
			},
		},
	},
}
