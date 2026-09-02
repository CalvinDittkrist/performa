-- Things that happen automatically in reaction to an event.
--
-- Read one as: "when EVENT happens, run CALLBACK".
-- List of events:  :help events

local function augroup(name)
	return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

-- Briefly highlight text after yanking it, so you can see what got copied.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Reopen a file at the line you last edited.
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_position"),
	callback = function(event)
		local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(event.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Strip trailing whitespace on save. Formatters handle this for most file types,
-- but plenty of files have no formatter configured.
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("trim_whitespace"),
	callback = function(event)
		-- Only touch real files. Writing out a special buffer (a :checkhealth
		-- report, a terminal, a plugin's scratch window) would throw, because
		-- substitution is not allowed there.
		if vim.bo[event.buf].buftype ~= "" then
			return
		end
		local view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

-- Close throwaway windows (help, man pages, quickfix) with a plain q.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "man", "qf", "checkhealth", "lspinfo", "startuptime" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
	end,
})

-- Wrap and spell-check prose, but not code.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("prose"),
	pattern = { "markdown", "gitcommit", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Warn instead of silently creating a file in a directory that does not exist.
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return -- remote path (scp://, term://, ...), nothing to create
		end
		local dir = vim.fn.fnamemodify(event.match, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})
