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

local function get_pane_path(pane)
  -- tmux内では pane.title に set-titles-string (pane_current_path) が入る
  -- tmux外では current_working_dir を使う
  local title = pane.title or ''
  if title:match('^/') then return title end
  local cwd = pane.current_working_dir
  if not cwd then return '' end
  return type(cwd) == 'string' and cwd or cwd.file_path
end

wezterm.on('format-tab-title', function(tab)
  local path = (get_pane_path(tab.active_pane):gsub('/$', ''))
  local name = path == os.getenv('HOME') and '~' or (path:match('([^/]+)$') or path)
  local title = string.format('   %s  ', name)

  if not tab.is_active then return title end
  return {
    { Background = { Color = '#181b39' } },
    { Foreground = { Color = '#ffffff' } },
    { Text = title },
  }
end)

return config
