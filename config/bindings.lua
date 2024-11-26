local wezterm = require("wezterm")
local platform = require("utils.platform")
-- local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
  mod.SUPER = "SUPER"
  mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_win or platform.is_linux then
  mod.SUPER = "ALT" -- to not conflict with Windows key shortcuts
  mod.SUPER_REV = "ALT|CTRL"
end

-- stylua: ignore
local keys = {
  -- misc/useful --
  {
    key = "p",
    mods = mod.SUPER,
    action = act.ActivateCommandPalette,
  },
  { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
  {
    key = '[',
    mods = mod.SUPER,
    action = "ActivateCopyMode",
  },

  { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
  { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
  { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
  {
    key = 'F5',
    mods = 'NONE',
    action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
  },
  { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
  { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
  { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
  {
    key = 'u',
    mods = mod.SUPER_REV,
    action = wezterm.action.QuickSelectArgs({
      label = 'open url',
      patterns = {
        '\\((https?://\\S+)\\)',
        '\\[(https?://\\S+)\\]',
        '\\{(https?://\\S+)\\}',
        '<(https?://\\S+)>',
        '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info('opening: ' .. url)
        wezterm.open_with(url)
      end),
    }),
  },

  -- cursor movement --
  { key = 'LeftArrow',  mods = mod.SUPER, action = act.SendString '\x1bOH' },
  { key = 'RightArrow', mods = mod.SUPER, action = act.SendString '\x1bOF' },
  { key = 'Backspace',  mods = mod.SUPER, action = act.SendString '\x15' },

  -- copy/paste --
  { key = "c",          mods = mod.SUPER, action = act.CopyTo("Clipboard") },
  { key = "v",          mods = mod.SUPER, action = act.PasteFrom("Clipboard") },

  -- tabs --
  { key = "t",          mods = mod.SUPER, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "q",          mods = mod.SUPER, action = act.QuitApplication },

  { key = "1",          mods = mod.SUPER, action = act.ActivateTab(0) },
  { key = "2",          mods = mod.SUPER, action = act.ActivateTab(1) },
  { key = "3",          mods = mod.SUPER, action = act.ActivateTab(2) },
  { key = "4",          mods = mod.SUPER, action = act.ActivateTab(3) },
  { key = "5",          mods = mod.SUPER, action = act.ActivateTab(4) },
  { key = "6",          mods = mod.SUPER, action = act.ActivateTab(5) },
  { key = "7",          mods = mod.SUPER, action = act.ActivateTab(6) },
  { key = "8",          mods = mod.SUPER, action = act.ActivateTab(7) },
  { key = "9",          mods = mod.SUPER, action = act.ActivateTab(-1) },

  -- tabs: navigation
  -- { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
  -- { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
  -- { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
  -- { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

  -- tab: title
  { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
  { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

  -- tab: hide tab-bar
  { key = '`',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

  -- panes --
  -- panes: split panes
  {
    key = [[\]],
    mods = mod.SUPER_REV,
    action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = [[\]],
    mods = mod.SUPER,
    action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },

  -- panes: zoom+close pane
  { key = 'Enter', mods = mod.SUPER, action = act.TogglePaneZoomState },
  { key = 'w',     mods = mod.SUPER, action = act.CloseCurrentPane({ confirm = false }) },

  -- panes: navigation
  { key = 'k',     mods = mod.SUPER, action = act.ActivatePaneDirection('Up') },
  { key = 'j',     mods = mod.SUPER, action = act.ActivatePaneDirection('Down') },
  { key = 'h',     mods = mod.SUPER, action = act.ActivatePaneDirection('Left') },
  { key = 'l',     mods = mod.SUPER, action = act.ActivatePaneDirection('Right') },
  {
    key = 'p',
    mods = mod.SUPER_REV,
    action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
  },

  -- panes: scroll pane
  { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
  { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
  { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
  { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },

  -- key-tables --
  -- resizes fonts
  {
    key = '=',
    mods = mod.SUPER,
    action = act.IncreaseFontSize,
  },
  {
    key = '-',
    mods = mod.SUPER,
    action = act.DecreaseFontSize,
  },
  {
    key = '=',
    mods = mod.SUPER_REV,
    action = act.ResetFontSize,
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = act.ActivateKeyTable({
      name = 'resize_font',
      one_shot = false,
      timemout_miliseconds = 1000,
    }),
  },
  -- resize panes
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateKeyTable({
      name = 'resize_pane',
      one_shot = false,
      timemout_miliseconds = 1000,
    }),
  },
}

-- stylua: ignore
local key_tables = {
  resize_font = {
    { key = 'k',      action = act.IncreaseFontSize },
    { key = 'j',      action = act.DecreaseFontSize },
    { key = 'r',      action = act.ResetFontSize },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q',      action = 'PopKeyTable' },
  },
  resize_pane = {
    { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
    { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
    { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
    { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q',      action = 'PopKeyTable' },
  },
}

local mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "SHIFT",
    action = act.OpenLinkAtMouseCursor,
  },
}

return {
  disable_default_key_bindings = true,
  -- disable_default_mouse_bindings = true,
  leader = { key = "'", mods = mod.SUPER },
  keys = keys,
  key_tables = key_tables,
  mouse_bindings = mouse_bindings,
}