local w = require("wezterm")

return {
	color_scheme = "Oceanic-Next",
	window_background_opacity = 0.8,
	text_background_opacity = 0.5,
	macos_window_background_blur = 80,
	inactive_pane_hsb = { brightness = 0.5 },

	-- https://github.com/be5invis/Sarasa-Gothic
	font = w.font("Sarasa Fixed J", { weight = "Light" }),
	font_size = 18,
	adjust_window_size_when_changing_font_size = false,

	initial_cols = 240,
	initial_rows = 56,

	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
	show_close_tab_button_in_tabs = false,

	keys = {
		-- This makes (Neo)Vim key map `<C-_>`(slash) works
		{ key = "/", mods = "CTRL", action = w.action({ SendString = "\x1f" }) },
		{ key = "D", mods = "SUPER", action = w.action.SplitVertical },
		{ key = "d", mods = "SUPER", action = w.action.SplitHorizontal },
		{ key = "[", mods = "SUPER", action = w.action({ ActivatePaneDirection = "Prev" }) },
		{ key = "]", mods = "SUPER", action = w.action({ ActivatePaneDirection = "Next" }) },
	},

	-- Disable the default click to open and requires SUPER+Click
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = w.action.DisableDefaultAssignment,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "SUPER",
			action = w.action.OpenLinkAtMouseCursor,
		},
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "SUPER",
			action = w.action.Nop,
		},
	},

	-- debug_key_events = true,
}
