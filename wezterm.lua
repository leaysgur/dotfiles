local w = require("wezterm")

return {
	color_scheme = "Pnevma",
	window_background_opacity = 0.9,
	text_background_opacity = 0.7,

	-- https://github.com/be5invis/Sarasa-Gothic
	font = w.font("Sarasa Fixed J Light"),
	font_size = 20,
	adjust_window_size_when_changing_font_size = false,

	initial_cols = 180,
	initial_rows = 50,

	inactive_pane_hsb = { brightness = 0.3 },
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,

	keys = {
		-- This makes (Neo)Vim key map `<C-_>`(slash) works
		{ key = "/", mods = "CTRL", action = w.action({ SendString = "\x1f" }) },
		{ key = "D", mods = "SUPER", action = w.action.SplitVertical },
		{ key = "d", mods = "SUPER", action = w.action.SplitHorizontal },
		{ key = "[", mods = "SUPER", action = w.action({ ActivatePaneDirection = "Prev" }) },
		{ key = "]", mods = "SUPER", action = w.action({ ActivatePaneDirection = "Next" }) },
	},

	-- debug_key_events = true,
}
