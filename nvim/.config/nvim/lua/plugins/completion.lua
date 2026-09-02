-- Autocompletion.
--
-- blink.cmp is the modern, fast completion engine. It needs far less
-- configuration than the older nvim-cmp, which is why it is used here.
--
-- While the popup is open:
--   <C-Space>  open it manually
--   <Tab>      accept the selected entry / jump to the next snippet placeholder
--   <C-j>/<C-k> or arrows to move
--   <C-e>      dismiss

return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*", -- release build, so no Rust toolchain is required
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "accept", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
			},

			appearance = { nerd_font_variant = "mono" },

			completion = {
				-- Show the documentation panel automatically after a short pause.
				documentation = { auto_show = true, auto_show_delay_ms = 300 },
				menu = { border = "rounded" },
				-- Only insert text when you explicitly accept, never while browsing.
				list = { selection = { preselect = true, auto_insert = false } },
			},

			signature = { enabled = true }, -- show parameter hints while typing a call

			-- Where suggestions come from, in priority order.
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}
