local wezterm = require("wezterm")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Use JetBrains Mono, which is built-in
config.font = wezterm.font("JetBrains Mono")

-- Disable the tab bar
config.enable_tab_bar = false

-- Use gruvbox
config.color_scheme = "Gruvbox dark, hard (base16)"

-- Use non-blinking bar by default
config.default_cursor_style = "SteadyBar"

-- Disable default key bindings (e.g., for C-S-[left/right] for tmux)
config.disable_default_key_bindings = true

-- Handle i3wm properly
config.adjust_window_size_when_changing_font_size = false

config.keys = {
  -- Copy/paste
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  -- Change font size
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "=",
    mods = "CTRL",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action.ResetFontSize,
  },
  -- Scroll up/down
  {
    key = "PageUp",
    action = wezterm.action.ScrollByPage(-0.5),
  },
  {
    key = "PageDown",
    action = wezterm.action.ScrollByPage(0.5),
  },
}

return config
