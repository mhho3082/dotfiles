local wezterm = require("wezterm")
return {
  -- Use JetBrains Mono, which is built-in
  font = wezterm.font("JetBrains Mono"),
  -- Disable the tab bar
  enable_tab_bar = false,
  -- Use gruvbox
  color_scheme = "Gruvbox dark, hard (base16)",
  -- Disable default key bindings (e.g., for C-S-[left/right] for tmux)
  disable_default_key_bindings = true,
  -- Handle i3wm properly
  adjust_window_size_when_changing_font_size = false,
  keys = {
    -- Add back copy/paste
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
  },
}
