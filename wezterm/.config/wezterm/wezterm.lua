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

-- Show the tab bar only once there is more than one tab: no wasted row while a
-- single shell is open, but the moment Cmd+T opens a second one you can see it
-- and click your way back. Turning it off entirely hides the fact that tabs
-- exist at all, which is only reasonable once tmux is doing that job for you.
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

config.window_padding = { left = 12, right = 12, top = 12, bottom = 8 }
-- Keep the macOS title bar. "RESIZE" alone looks tidier but removes the
-- traffic lights with it, so there is no visible way to close the window.
config.window_decorations = "TITLE | RESIZE"
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
