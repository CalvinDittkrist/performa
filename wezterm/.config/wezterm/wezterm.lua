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

-- Cmd+Arrow splits the terminal towards the arrow.
--
-- tmux owns the panes here, so the natural place for this would be tmux itself
-- - except macOS never delivers Cmd to a terminal program, so tmux can only
-- ever see the keys WezTerm chooses to forward. This forwards the tmux
-- keystroke for a directional split: the prefix (Ctrl+Space), then the arrow.
-- The matching bindings live in tmux.conf under "Directional splits".
--
-- When tmux is not running, the same shortcut splits a WezTerm pane instead, so
-- it does the obvious thing either way rather than emitting stray characters
-- into the shell.
--
-- Shift+Arrow is deliberately *not* bound here: tmux handles it directly, and
-- binding it would swallow the key before tmux ever saw it.

local function running_tmux(pane)
	local process = pane:get_foreground_process_name()
	return process ~= nil and process:find("tmux") ~= nil
end

local function split(arrow, wezterm_direction)
	return wezterm.action_callback(function(window, pane)
		if running_tmux(pane) then
			window:perform_action(
				wezterm.action.Multiple({
					wezterm.action.SendKey({ key = "Space", mods = "CTRL" }), -- tmux prefix
					wezterm.action.SendKey({ key = arrow }),
				}),
				pane
			)
		else
			window:perform_action(
				wezterm.action.SplitPane({ direction = wezterm_direction }),
				pane
			)
		end
	end)
end

config.keys = {
	-- Cmd+Enter toggles fullscreen (WezTerm has no default for this).
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},

	{ key = "RightArrow", mods = "CMD", action = split("RightArrow", "Right") },
	{ key = "LeftArrow", mods = "CMD", action = split("LeftArrow", "Left") },
	{ key = "DownArrow", mods = "CMD", action = split("DownArrow", "Down") },
	{ key = "UpArrow", mods = "CMD", action = split("UpArrow", "Up") },
}

return config
