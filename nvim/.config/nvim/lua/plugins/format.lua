-- Formatting on save.
--
-- conform.nvim runs the right formatter for each file type. The binaries are
-- installed by mason-tool-installer (see lua/plugins/lsp.lua).
--
--   <leader>cf   format now
--   <leader>uf   toggle format-on-save (handy in a repo with a different style)

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format file",
		},
		{
			"<leader>uf",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
			end,
			desc = "Toggle format on save",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return {
				timeout_ms = 1000,
				-- If no formatter is configured for this file type, let the language
				-- server format it instead of doing nothing.
				lsp_format = "fallback",
			}
		end,
	},
}
