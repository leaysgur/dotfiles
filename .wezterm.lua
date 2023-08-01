local wezterm = require("wezterm")
local act = wezterm.action

return {
	font = wezterm.font("UDEV Gothic NF"),
	font_size = 20,
	adjust_window_size_when_changing_font_size = false,
	initial_cols = 150,
	initial_rows = 50,
	window_padding = {
		top = 4,
		left = 4,
		right = 0,
		bottom = 0,
	},
	color_scheme = "Arthur",
	window_background_opacity = 0.9,
	text_background_opacity = 0.6,
	inactive_pane_hsb = { brightness = 0.2 },
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	keys = {
		-- This makes (Neo)Vim key map `<C-_>`(slash) works
		{ key = "/", mods = "CTRL", action = act({ SendString = "\x1f" }) },
		{ key = "D", mods = "SUPER", action = act.SplitVertical },
		{ key = "d", mods = "SUPER", action = act.SplitHorizontal },
		{ key = "[", mods = "SUPER", action = act({ ActivatePaneDirection = "Prev" }) },
		{ key = "]", mods = "SUPER", action = act({ ActivatePaneDirection = "Next" }) },
	},
	mouse_bindings = {
		-- Do nothing on click hyper links without `CMD` key
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelection("PrimarySelection"),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "SUPER",
			action = act.OpenLinkAtMouseCursor,
		},
	},
	hyperlink_rules = {
		-- Default rule for general url
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},
		-- Support url like http://127.0.0.1:8000
		{
			regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b",
			format = "$0",
		},
	},
	-- debug_key_events = true,
}
