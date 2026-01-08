local wezterm = require 'wezterm'
local act = wezterm.action;

local config = {}

---------------------------------------------------------
---- Looks ----------------------------------------------
---------------------------------------------------------
-- Fonts:
--   - FiraCode Nerd Font      10
--   - Hurmit Nerd Font        10
--   - CaskaydiaCove Nerd Font 11
--   - Mononoki Nerd Font      11
--   - Monofur Nerd Font       12.5
config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' })
config.font_size = 10

config.command_palette_font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' })
config.command_palette_font_size = 10

-- TODO: colors when highlight text on copy/search mode
-- https://gogh-co.github.io/Gogh/
-- https://terminal.sexy/
--
-- Themes:
--   - Dracula (Gogh)
--   - Monokai Soda (Gogh)
--   - Sonokai (Gogh)
--   - Spacegray (Gogh)
--   - Sweet Eliverlara (Gogh)
--   - Ayu Mirage (Gogh)
config.color_scheme = 'Sonokai (Gogh)'

config.enable_scroll_bar = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = '4px',
  right = '3px',
  top = 0,
  bottom = 0,
}

-- Initial sizes
config.initial_cols = 150
config.initial_rows = 40
config.scrollback_lines = 3500

---------------------------------------------------------
---- Other ----------------------------------------------
---------------------------------------------------------
config.adjust_window_size_when_changing_font_size = false
config.switch_to_last_active_tab_when_closing_tab = true

config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.audible_bell = 'Disabled'
config.warn_about_missing_glyphs = false

---------------------------------------------------------
---- Mouse ----------------------------------------------
---------------------------------------------------------

config.disable_default_mouse_bindings = true

config.mouse_bindings = {
  -- Left click creates selections
  { mods = 'NONE', event = { Down = { button = 'Left', streak = 1 }}, action = act.SelectTextAtMouseCursor 'Cell' },
  { mods = 'NONE', event = { Down = { button = 'Left', streak = 2 }}, action = act.SelectTextAtMouseCursor 'Word' },
  { mods = 'NONE', event = { Down = { button = 'Left', streak = 3 }}, action = act.SelectTextAtMouseCursor 'Line' },

  -- Dragging left click extends selections
  { mods = 'NONE', event = { Drag = { button = 'Left', streak = 1 }}, action = act.ExtendSelectionToMouseCursor 'Cell' },
  { mods = 'NONE', event = { Drag = { button = 'Left', streak = 2 }}, action = act.ExtendSelectionToMouseCursor 'Word' },
  { mods = 'NONE', event = { Drag = { button = 'Left', streak = 3 }}, action = act.ExtendSelectionToMouseCursor 'Line' },

  -- Scrolling
  { mods = 'NONE', event = { Down = { button = { WheelUp = 1   }, streak = 1 } }, action = act.ScrollByLine(-10) },
  { mods = 'NONE', event = { Down = { button = { WheelDown = 1 }, streak = 1 } }, action = act.ScrollByLine(10) },
  { mods = 'CTRL', event = { Down = { button = { WheelUp = 1   }, streak = 1 } }, action = act.ScrollByPage(-1) },
  { mods = 'CTRL', event = { Down = { button = { WheelDown = 1 }, streak = 1 } }, action = act.ScrollByPage(1) },

  -- Other actions
  { mods = 'SHIFT', event = { Down = { button = 'Left', streak = 1 }}, action = act.ExtendSelectionToMouseCursor 'Cell' },
  { mods = 'CTRL',  event = { Down = { button = 'Left', streak = 1 }}, action = act.OpenLinkAtMouseCursor },
  { mods = 'ALT',   event = { Drag = { button = 'Left', streak = 1 }}, action = act.SelectTextAtMouseCursor 'Block' },
}

---------------------------------------------------------
---- Keymaps --------------------------------------------
---------------------------------------------------------
config.disable_default_key_bindings = true

config.keys = {
  ---------------------------------------------------------
  ---- Tabs -----------------------------------------------
  ---------------------------------------------------------
  { mods = 'ALT', key = 't', action = act.SpawnTab 'CurrentPaneDomain'  },
  { mods = 'ALT', key = 'w', action = act.CloseCurrentTab { confirm = true } },

  -- Switch tabs
  { mods = 'ALT', key = ']', action = act.ActivateTabRelative(1) },
  { mods = 'ALT', key = '[', action = act.ActivateTabRelative(-1) },
  { mods = 'ALT', key = '.', action = act.ActivateLastTab },

  { mods = 'ALT', key = '1', action = act.ActivateTab(0) },
  { mods = 'ALT', key = '2', action = act.ActivateTab(1) },
  { mods = 'ALT', key = '3', action = act.ActivateTab(2) },
  { mods = 'ALT', key = '4', action = act.ActivateTab(3) },
  { mods = 'ALT', key = '5', action = act.ActivateTab(4) },
  { mods = 'ALT', key = '6', action = act.ActivateTab(5) },
  { mods = 'ALT', key = '7', action = act.ActivateTab(6) },
  { mods = 'ALT', key = '8', action = act.ActivateTab(7) },
  { mods = 'ALT', key = '9', action = act.ActivateTab(8) },

  -- Move tabs
  { mods = 'ALT',       key = '}', action = act.MoveTabRelative(1) }, -- US keywoard
  { mods = 'ALT',       key = '{', action = act.MoveTabRelative(-1) },
  { mods = 'ALT|SHIFT', key = '}', action = act.MoveTabRelative(1) }, -- EU keyboard
  { mods = 'ALT|SHIFT', key = '{', action = act.MoveTabRelative(-1) },

  ---------------------------------------------------------
  ---- Panes ----------------------------------------------
  ---------------------------------------------------------
  { mods = 'ALT', key = 'v', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  { mods = 'ALT', key = 'b', action = act.SplitVertical   { domain = 'CurrentPaneDomain' }},

  -- Zoom mode
  { mods = 'ALT', key = 'Enter', action = act.TogglePaneZoomState },
  { mods = 'ALT', key = 'z',     action = act.TogglePaneZoomState },

  -- Close pane
  { mods = 'ALT', key = 'x', action = act.CloseCurrentPane { confirm = true } },

  -- Switch Panes
  { mods = 'ALT', key = 's', action = act.PaneSelect { mode = 'Activate', alphabet = '123456789' } },

  { mods = 'ALT', key = 'k', action = act.ActivatePaneDirection 'Up' },
  { mods = 'ALT', key = 'j', action = act.ActivatePaneDirection 'Down' },
  { mods = 'ALT', key = 'h', action = act.ActivatePaneDirection 'Left' },
  { mods = 'ALT', key = 'l', action = act.ActivatePaneDirection 'Right' },

  { mods = 'ALT', key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
  { mods = 'ALT', key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
  { mods = 'ALT', key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
  { mods = 'ALT', key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },

  -- Move panes
  { mods = 'ALT', key = 'm', action = act.RotatePanes 'Clockwise' },
  { mods = 'ALT', key = 'S', action = act.PaneSelect { mode = 'SwapWithActive', alphabet = '123456789' } },
  { mods = 'ALT', key = 'T', action = act.PaneSelect { mode = 'MoveToNewTab', alphabet = '123456789' } },
  -- TODO: move to existing tab

  -- Resize mode
  { mods = 'ALT', key = 'r', action = act.ActivateKeyTable {
    name = 'resize_mode',
    one_shot = false,
    replace_current = true,
    until_unknown = true,
  }},

  ---------------------------------------------------------
  ---- Scroll ---------------------------------------------
  ---------------------------------------------------------
  -- Scroll lines
  { mods = 'NONE', key = 'PageUp',    action = act.ScrollByLine(-1) },
  { mods = 'NONE', key = 'PageDown',  action = act.ScrollByLine(1) },
  { mods = 'CTRL', key = 'UpArrow',   action = act.ScrollByLine(-1) },
  { mods = 'CTRL', key = 'DownArrow', action = act.ScrollByLine(1) },

  -- Scroll pages
  { mods = 'CTRL',       key = 'PageUp',    action = act.ScrollByPage(-1) },
  { mods = 'CTRL',       key = 'PageDown',  action = act.ScrollByPage(1) },
  { mods = 'CTRL|SHIFT', key = 'UpArrow',   action = act.ScrollByPage(-1) },
  { mods = 'CTRL|SHIFT', key = 'DownArrow', action = act.ScrollByPage(1) },

  -- Scroll to prompt
  { mods = 'SHIFT', key = 'UpArrow',   action = act.ScrollToPrompt(-1) },
  { mods = 'SHIFT', key = 'DownArrow', action = act.ScrollToPrompt(1) },

  -- Other scroll movements
  { mods = 'NONE', key = 'End',  action = act.ScrollToBottom },
  { mods = 'NONE', key = 'Home', action = act.ScrollToTop },

  -- Clear scroll back
  { mods = 'ALT|SHIFT', key = 'L', action = act.ClearScrollback 'ScrollbackAndViewport'},

  ---------------------------------------------------------
  ---- Modes ----------------------------------------------
  ---------------------------------------------------------
  -- Debug overlay
  -- It can be used to run lua code, to evaluate math expressions (as
  -- a calculator) for example
  { mods = 'ALT', key = 'd', action = act.ShowDebugOverlay },

  -- TODO: Quick select mode (haven't found a use for it yet)
  -- { mods = 'ALT', key = 'a', action = act.QuickSelect },

  -- Search mode
  { mods = 'ALT', key = 'f', action = act.Search 'CurrentSelectionOrEmptyString' },

  -- Copy mode
  { mods = 'ALT', key = 'c', action = act.ActivateCopyMode },

  -- Copy & Paste
  { mods = 'CTRL|SHIFT', key = 'c', action = act.CopyTo 'Clipboard' },
  { mods = 'CTRL|SHIFT', key = 'v', action = act.PasteFrom 'Clipboard' },

  -- Modal Palette
  { mods = 'ALT|SHIFT', key = 'P', action = act.ActivateCommandPalette },

  -- Launcher Menu
  { mods = 'ALT', key = '0', action = act.ShowLauncherArgs { flags = 'FUZZY|LAUNCH_MENU_ITEMS' } },

  -- Quickly launch python
  { mods = 'ALT', key = 'p', action = act.SplitPane {
      direction = 'Right',
      size = { Cells = 40 },
      command = { label = 'Run Python', args = { 'python3', '-qic', 'from math import *; from statistics import *;' } },
      top_level = true,
    }
  },

  -- Launch yazi in a new tab
  { mods = 'ALT', key = 'y', action = act.SpawnCommandInNewTab {
      label = 'Open yazi in a new tab',
      args = { 'yazi' },
    }
  },

  -- Launch yazi in a split pane
  { mods = 'ALT', key = 'Y', action = act.SplitPane {
      direction = 'Right',
      command = { label = 'Run yazi in a split pane', args = { 'yazi' }},
    }
  },

  -- Font resize
  { mods = 'CTRL', key = '+', action = act.IncreaseFontSize },
  { mods = 'CTRL', key = '-', action = act.DecreaseFontSize },
  { mods = 'CTRL', key = '0', action = act.ResetFontSize },

  -- Reload this config
  { mods = 'ALT|SHIFT', key = 'R', action = act.ReloadConfiguration },
}

config.key_tables = {
  ---------------------------------------------------------
  ---- Resize mode ----------------------------------------
  ---------------------------------------------------------
  resize_mode = {
    -- Resize easily with the Vim keys
    { mods = 'NONE', key = 'h', action = act.AdjustPaneSize { 'Left',  10 } },
    { mods = 'NONE', key = 'l', action = act.AdjustPaneSize { 'Right', 10 } },
    { mods = 'NONE', key = 'j', action = act.AdjustPaneSize { 'Down',  10 } },
    { mods = 'NONE', key = 'j', action = act.AdjustPaneSize { 'Up',    10 } },

    -- The arrows allow for greater control (rarely used)
    { mods = 'NONE', key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left',  1 } },
    { mods = 'NONE', key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { mods = 'NONE', key = 'DownArrow',  action = act.AdjustPaneSize { 'Down',  1 } },
    { mods = 'NONE', key = 'UpArrow',    action = act.AdjustPaneSize { 'Up',    1 } },

    -- Quit the mode
    { mods = 'NONE', key = 'Escape', action = act.PopKeyTable },
    { mods = 'NONE', key = 'Enter',  action = act.PopKeyTable },
  },

  ---------------------------------------------------------
  ---- Search mode ----------------------------------------
  ---------------------------------------------------------
  search_mode = {
    { mods = 'CTRL', key = 'r', action = act.CopyMode 'CycleMatchType' }, -- Case-sensitive, case-insensitive, regex
    { mods = 'CTRL', key = 'u', action = act.CopyMode 'ClearPattern' },

    -- Search previous
    { mods = 'NONE', key = 'Enter',   action = act.CopyMode 'PriorMatch' },
    { mods = 'CTRL', key = 'p',       action = act.CopyMode 'PriorMatch' },
    { mods = 'NONE', key = 'UpArrow', action = act.CopyMode 'PriorMatch' },
    -- { mods = 'NONE', key = 'PageUp',  action = act.CopyMode 'PriorMatchPage' },

    -- Search next
    { mods = 'CTRL', key = 'n',         action = act.CopyMode 'NextMatch' },
    { mods = 'NONE', key = 'DownArrow', action = act.CopyMode 'NextMatch' },
    -- { mods = 'NONE', key = 'PageDown',  action = act.CopyMode 'NextMatchPage' },

    -- Quit
    { mods = 'NONE', key = 'Escape', action = act.CopyMode 'Close' },
    { mods = 'CTRL', key = 'c',      action = act.CopyMode 'Close' },
  },

  ---------------------------------------------------------
  ---- Copy mode ------------------------------------------
  ---------------------------------------------------------
  copy_mode = {
    -- Copy and exit
    { mods = 'NONE', key = 'y',     action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
    { mods = 'NONE', key = 'Enter', action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },

    -- Close without copying
    { mods = 'NONE',   key = 'Escape',     action = act.CopyMode 'Close' },
    { mods = 'CTRL',   key = 'c',          action = act.CopyMode 'Close' },
    { mods = 'NONE',   key = 'q',          action = act.CopyMode 'Close' },

    -- Selection modes
    { mods = 'NONE',   key = 'Space',      action = act.CopyMode { SetSelectionMode =  'Cell' } },
    { mods = 'NONE',   key = 'v',          action = act.CopyMode { SetSelectionMode = 'Cell' } },
    { mods = 'CTRL',   key = 'v',          action = act.CopyMode { SetSelectionMode = 'Block' } },
    { mods = 'NONE',   key = 'V',          action = act.CopyMode { SetSelectionMode = 'Line' } },
    { mods = 'SHIFT',  key = 'V',          action = act.CopyMode { SetSelectionMode = 'Line' } },

    { mods = 'NONE',   key = 'o',          action = act.CopyMode 'MoveToSelectionOtherEnd' },
    { mods = 'NONE',   key = 'O',          action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
    { mods = 'SHIFT',  key = 'O',          action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },

    -- Vim movement
    { mods = 'NONE',   key = 'w',          action = act.CopyMode 'MoveForwardWord' },
    { mods = 'NONE',   key = 'b',          action = act.CopyMode 'MoveBackwardWord' },
    { mods = 'NONE',   key = 'e',          action = act.CopyMode 'MoveForwardWordEnd' },

    { mods = 'NONE',   key = 'h',          action = act.CopyMode 'MoveLeft' },
    { mods = 'NONE',   key = 'j',          action = act.CopyMode 'MoveDown' },
    { mods = 'NONE',   key = 'k',          action = act.CopyMode 'MoveUp' },
    { mods = 'NONE',   key = 'l',          action = act.CopyMode 'MoveRight' },
    { mods = 'NONE',   key = 'LeftArrow',  action = act.CopyMode 'MoveLeft' },
    { mods = 'NONE',   key = 'DownArrow',  action = act.CopyMode 'MoveDown' },
    { mods = 'NONE',   key = 'UpArrow',    action = act.CopyMode 'MoveUp' },
    { mods = 'NONE',   key = 'RightArrow', action = act.CopyMode 'MoveRight' },

    -- Line jumping
    { mods = 'NONE',   key = '0',          action = act.CopyMode 'MoveToStartOfLine' },
    { mods = 'NONE',   key = '-',          action = act.CopyMode 'MoveToStartOfLineContent' },
    { mods = 'NONE',   key = 'Home',       action = act.CopyMode 'MoveToStartOfLine' },

    { mods = 'NONE',   key = '$',          action = act.CopyMode 'MoveToEndOfLineContent' },
    { mods = 'SHIFT',  key = '$',          action = act.CopyMode 'MoveToEndOfLineContent' },
    { mods = 'NONE',   key = '+',          action = act.CopyMode 'MoveToEndOfLineContent' },
    { mods = 'NONE',   key = 'End',        action = act.CopyMode 'MoveToEndOfLineContent' },

    -- Search
    { mods = 'NONE',   key = 'f',          action = act.CopyMode { JumpForward = { prev_char = false } } },
    { mods = 'NONE',   key = 'F',          action = act.CopyMode { JumpBackward = { prev_char = false } } },
    { mods = 'SHIFT',  key = 'F',          action = act.CopyMode { JumpBackward = { prev_char = false } } },
    { mods = 'NONE',   key = 't',          action = act.CopyMode { JumpForward = { prev_char = true } } },
    { mods = 'NONE',   key = 'T',          action = act.CopyMode { JumpBackward = { prev_char = true } } },
    { mods = 'SHIFT',  key = 'T',          action = act.CopyMode { JumpBackward = { prev_char = true } } },
    { mods = 'NONE',   key = ',',          action = act.CopyMode 'JumpAgain' },
    { mods = 'NONE',   key = ';',          action = act.CopyMode 'JumpReverse' },

    -- Scroll
    { mods = 'NONE',   key = 'g',          action = act.CopyMode 'MoveToScrollbackTop' },
    { mods = 'NONE',   key = 'G',          action = act.CopyMode 'MoveToScrollbackBottom' },
    { mods = 'SHIFT',  key = 'G',          action = act.CopyMode 'MoveToScrollbackBottom' },

    { mods = 'CTRL',   key = 'u',          action = act.CopyMode { MoveByPage = (-0.5) } },
    { mods = 'CTRL',   key = 'd',          action = act.CopyMode { MoveByPage = (0.5) } },

    { mods = 'CTRL',   key = 'f',          action = act.CopyMode 'PageDown' },
    { mods = 'NONE',   key = 'PageDown',   action = act.CopyMode 'PageDown' },

    { mods = 'CTRL',   key = 'b',          action = act.CopyMode 'PageUp' },
    { mods = 'NONE',   key = 'PageUp',     action = act.CopyMode 'PageUp' },

    { mods = 'NONE',   key = 'H',          action = act.CopyMode 'MoveToViewportTop' },
    { mods = 'SHIFT',  key = 'H',          action = act.CopyMode 'MoveToViewportTop' },
    { mods = 'NONE',   key = 'L',          action = act.CopyMode 'MoveToViewportBottom' },
    { mods = 'SHIFT',  key = 'L',          action = act.CopyMode 'MoveToViewportBottom' },
    { mods = 'NONE',   key = 'M',          action = act.CopyMode 'MoveToViewportMiddle' },
    { mods = 'SHIFT',  key = 'M',          action = act.CopyMode 'MoveToViewportMiddle' },
  },
}

---------------------------------------------------------
---- Launch menu ----------------------------------------
---------------------------------------------------------
-- TODO: More
config.launch_menu = {
  -- { label = 'htop', args = {'htop'}, cwd = '/home/magno' },
}

return config
