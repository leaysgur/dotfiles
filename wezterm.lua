local wezterm = require("wezterm")
local act = wezterm.action

return {
	-- https://github.com/be5invis/Sarasa-Gothic
	font = wezterm.font("Sarasa Fixed J"),
	font_size = 18,
	adjust_window_size_when_changing_font_size = false,
	initial_cols = 200,
	initial_rows = 50,
	color_scheme = "Oceanic-Next",
	window_background_opacity = 0.8,
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
	-- debug_key_events = true,
}
