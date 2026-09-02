-- Neovim entry point.
--
-- This file stays deliberately tiny: it only loads the four modules below,
-- in order. Everything you might want to change lives in one of them.
--
--   lua/config/options.lua   editor behaviour (line numbers, tabs, search, ...)
--   lua/config/keymaps.lua   every shortcut you own
--   lua/config/autocmds.lua  things that react to events
--   lua/config/lazy.lua      bootstraps the plugin manager, loads lua/plugins/*

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
