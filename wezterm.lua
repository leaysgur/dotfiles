local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Afterglow"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 25
config.inactive_pane_hsb = { brightness = 0.6 }

config.font = wezterm.font("Sarasa Fixed J", { weight = "Light" })
config.harfbuzz_features = { "calt = 0", "clig = 0", "liga = 0" }
config.font_size = 18
config.adjust_window_size_when_changing_font_size = false

config.initial_cols = 240
config.initial_rows = 54
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
-- config.show_close_tab_button_in_tabs = false

config.keys = {
	{ key = "D", mods = "SUPER", action = wezterm.action.SplitVertical },
	{ key = "d", mods = "SUPER", action = wezterm.action.SplitHorizontal },
	{ key = "[", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Prev" }) },
	{ key = "]", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Next" }) },
	-- This makes (Neo)Vim key map `<C-_>`(slash) works
	{ key = "/", mods = "CTRL", action = wezterm.action({ SendString = "\x1f" }) },
	-- This makes ClaudeCode SHIT+Enter works
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

return config
