local wezterm = require("wezterm")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Use JetBrains Mono, which is built-in
-- Emojis will need Noto Emoji installed
config.font = wezterm.font("JetBrainsMono NF")
-- https://github.com/JetBrains/JetBrainsMono#opentype-features
-- https://wezfurlong.org/wezterm/config/font-shaping.html
config.harfbuzz_features = { "ss19", "cv07", "cv99" }

-- Or use FiraCode, which is also built-in; stylistic sets can be enabled
-- config.font = wezterm.font("FiraCode")
-- config.harfbuzz_features = { "zero", "ss01", "ss03", "ss05", "ss06", "ss08" }

-- Set font size
config.font_size = 12.0

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

-- Disable IME
config.use_ime = false

-- Disable bell
config.audible_bell = "Disabled"

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
