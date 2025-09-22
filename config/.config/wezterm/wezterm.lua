local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = "Catppuccin Mocha"

-- Font configuration
config.font_size = 10.0
config.cell_width = 0.8
config.line_height = 0.8

-- Window appearance
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Terminal behavior
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "CursorColor",
}

-- Keys and shortcuts
config.keys = {
	-- Copy/Paste
	{
		key = "c",
		mods = "ALT",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		key = "v",
		mods = "ALT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	-- Split panes
	{
		key = "\\",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Navigate between panes
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	-- Adjust pane size
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
}

-- Mouse bindings
config.mouse_bindings = {
	-- Right click pastes from the clipboard
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

return config
