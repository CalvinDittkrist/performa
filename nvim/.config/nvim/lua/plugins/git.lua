-- Git integration inside the editor.
--
-- Heavy lifting (staging, committing, branches) happens in lazygit, which opens
-- in its own terminal window with <leader>gg. gitsigns covers the small stuff
-- you want without leaving the buffer.

return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▁" },
				topdelete = { text = "▔" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local function map(mode, keys, action, desc)
					vim.keymap.set(mode, keys, action, { buffer = bufnr, desc = desc })
				end

				-- A "hunk" is one contiguous block of changed lines.
				map("n", "]h", function() gs.nav_hunk("next") end, "Next change")
				map("n", "[h", function() gs.nav_hunk("prev") end, "Previous change")

				map("n", "<leader>gp", gs.preview_hunk, "Preview change")
				map("n", "<leader>gs", gs.stage_hunk, "Stage change")
				map("n", "<leader>gr", gs.reset_hunk, "Discard change")
				map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Who wrote this line")
				map("n", "<leader>gd", gs.diffthis, "Diff against HEAD")
			end,
		},
	},

	-- Opens lazygit in a floating terminal. Quit it with q as usual; Neovim
	-- reloads any file lazygit changed underneath it.
	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit", "LazyGitCurrentFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open lazygit" },
		},
	},
}
