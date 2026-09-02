-- Bootstraps lazy.nvim, the plugin manager.
--
-- lazy.nvim downloads itself on first launch, then reads every file in
-- lua/plugins/ and installs whatever they declare.
--
-- Useful commands:
--   :Lazy         open the plugin dashboard (install / update / profile)
--   :Lazy sync    install missing plugins and update the rest
--   :Lazy clean   remove plugins no longer listed in lua/plugins/

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Load every lua/plugins/*.lua file.
	spec = { { import = "plugins" } },

	-- Plugins are pinned by lazy-lock.json, which lives in this repo. Automatic
	-- update checks would only nag; run :Lazy sync when you actually want them.
	checker = { enabled = false },
	change_detection = { notify = false },

	install = { colorscheme = { "catppuccin" } },

	performance = {
		rtp = {
			-- Disable bundled Vim plugins we do not use; a few of them are slow.
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"netrwPlugin", -- neo-tree replaces netrw
			},
		},
	},
})
