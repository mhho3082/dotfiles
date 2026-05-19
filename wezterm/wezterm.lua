local wezterm = require("wezterm")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Check if the target platform is macOS
-- https://github.com/wez/wezterm/discussions/4728
local is_darwin = wezterm.target_triple:find("darwin") ~= nil

-- Use JetBrains Mono (built-in)
-- Emojis will need Noto Emoji installed
config.font = wezterm.font("JetBrainsMono NF")
-- https://github.com/JetBrains/JetBrainsMono#opentype-features
-- https://wezfurlong.org/wezterm/config/font-shaping.html
config.harfbuzz_features = { "ss19", "cv07", "cv99" }

-- Or use FiraCode (built-in)
-- config.font = wezterm.font("FiraCode")
-- config.harfbuzz_features = { "zero", "ss01", "ss03", "ss05", "ss06", "ss08" }

-- Set font size
config.font_size = is_darwin and 15.0 or 12.0

-- Use tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

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

-- On bell, give a toast notification
wezterm.on("bell", function(window, _)
  window:toast_notification("WezTerm", 'Bell from tab "' .. window:active_tab():get_title() .. '"')
end)

-- Give a reasonable title to the terminal window (for macOS)
wezterm.on("format-window-title", function(tab)
  return "WezTerm: " .. tab.active_pane.title
end)

if not is_darwin then
  -- Fix cursor theme on i3
  -- https://github.com/wezterm/wezterm/issues/1742#issuecomment-1075333507
  local xcursor_size = nil
  local xcursor_theme = nil

  local success, stdout, _ =
    wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-theme" })
  if success then
    xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
  end

  local _success, _stdout, _ =
    wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-size" })
  if _success then
    xcursor_size = tonumber(_stdout)
  end

  config.xcursor_theme = xcursor_theme
  config.xcursor_size = xcursor_size
end

config.keys = {
  -- Copy/paste
  { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
  { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search({CaseSensitiveString=""}) },
  { key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },
  -- Change font size
  { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
  { key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
  { key = "=", mods = "CTRL", action = wezterm.action.ResetFontSize },
  -- Scroll up/down
  { key = "PageUp", mods = "SHIFT", action = wezterm.action.ScrollByPage(-0.5) },
  { key = "PageDown", mods = "SHIFT", action = wezterm.action.ScrollByPage(0.5) },
  -- Tabs
  { key = "t", mods = "CTRL", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
  {
    key = ",",
    mods = "CTRL",
    action = wezterm.action.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  { key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) },
  { key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
  { key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },
  { key = "0", mods = "ALT", action = wezterm.action.ActivateTab(-1) },
  -- Windows
  { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
}

return config
