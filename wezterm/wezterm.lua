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
  },
}
