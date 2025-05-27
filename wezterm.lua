local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
  { family = 'Hack Nerd Font Mono', assume_emoji_presentation = false },
  { family = 'Hack Nerd Font Mono', assume_emoji_presentation = true },
  { family = 'ヒラギノ角ゴシック' },
}
config.font_size = 15
config.color_scheme = 'Tokyo Night'
config.keys = {
  { key = 'LeftArrow',  mods = 'OPT', action = wezterm.action { SendString = '\x1bb' } },
  { key = 'RightArrow', mods = 'OPT', action = wezterm.action { SendString = '\x1bf' } },
}
config.initial_rows = 60
config.initial_cols = 160

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

return config
