-- WezTerm configuration.
--
-- Deliberately small: tmux handles tabs, panes and sessions, so WezTerm only has
-- to be a good-looking, fast window that stays out of the way.
--
-- Reload: WezTerm watches this file and applies changes instantly, no restart.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------------------------

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Menlo", -- always present on macOS, so we never end up with no font at all
})
config.font_size = 14.0
config.line_height = 1.1

-- tmux draws its own status line at the bottom, so WezTerm's tab bar would just
-- be a second, redundant row of tabs.
config.enable_tab_bar = false

config.window_padding = { left = 12, right = 12, top = 12, bottom = 8 }
config.window_decorations = "RESIZE" -- no title bar, but still resizable
config.window_background_opacity = 0.96
config.macos_window_background_blur = 20

config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- ---------------------------------------------------------------------------
-- Keys
-- ---------------------------------------------------------------------------
--
-- Almost nothing is bound here on purpose:
--   * Cmd+C / Cmd+V / Cmd+N / Cmd+F etc. keep their macOS defaults.
--   * Ctrl+Space MUST stay untouched - it is the tmux prefix. Binding it here
--     would swallow the key before tmux ever sees it.

config.keys = {
	-- Cmd+Enter toggles fullscreen (WezTerm has no default for this).
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
}

return config
