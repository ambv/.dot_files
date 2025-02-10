
local wezterm = require 'wezterm'
local default_prog = {"/opt/homebrew/bin/xonsh", "-l"}

return {
  default_prog= default_prog,
  font = wezterm.font("Terminus (TTF)"),
  font_size = 14.0,
  cell_width = 1.05,
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = false,
  quit_when_all_windows_are_closed = false,
  window_padding = {left=28, right=28, top=28, bottom=28},
  initial_rows = 30,
  initial_cols = 100,
  use_fancy_tab_bar = false,
  tab_max_width = 80,
  colors = {
    foreground = '#e0e0e0',
    tab_bar = {
      background = 'hsl(280, 100%, 11%)',
      active_tab = {
        bg_color = 'hsl(240, 100%, 66%)',
        fg_color = 'hsl(240, 100%, 100%)',
      },
      inactive_tab = {
        bg_color = 'hsl(260, 100%, 30%)',
        fg_color = 'hsl(260, 100%, 80%)',
      },
      inactive_tab_hover = {
        bg_color = 'hsl(220, 100%, 66.66%)',
        fg_color = 'hsl(220, 100%, 100%)',
      },
      new_tab = {
        bg_color = 'hsl(280, 100%, 11%)',
        fg_color = 'hsl(260, 100%, 80%)',
      },
      new_tab_hover = {
        bg_color = 'hsl(230, 100%, 70%)',
        fg_color = 'hsl(260, 100%, 100%)',
      },
    },
    scrollbar_thumb = 'hsl(280, 25%, 11%)',
    split = 'hsl(280, 25%, 11%)',
  },
  enable_scroll_bar = true,
  scrollback_lines = 10000,
  window_decorations = 'RESIZE',
  keys = {
    {key="t", mods="CMD", action=wezterm.action.SpawnCommandInNewTab{args=default_prog, cwd=wezterm.home_dir}},
    {key="w", mods="CMD", action=wezterm.action.CloseCurrentPane{confirm=false}},
    {key="c", mods="CMD", action=wezterm.action{CopyTo="Clipboard"}},
    {key="v", mods="CMD", action=wezterm.action{PasteFrom="Clipboard"}},
    -- splits
    {key="d", mods="CMD", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="D", mods="CMD", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},
    {key="[", mods="CMD", action=wezterm.action.ActivatePaneDirection "Prev"},
    {key="]", mods="CMD", action=wezterm.action.ActivatePaneDirection "Next"},
    -- disable defaults
    {key="-", mods="CTRL", action="DisableDefaultAssignment"},
    {key="_", mods="CTRL|SHIFT", action="DisableDefaultAssignment"},
    {key="+", mods="CTRL", action="DisableDefaultAssignment"},
    {key="Enter", mods="META", action="DisableDefaultAssignment"},
  },
  mouse_bindings = {
    -- only select text by default
    {
        event={Up={streak=1, button="Left"}},
        mods="NONE",
        action=wezterm.action.CompleteSelection("PrimarySelection"),
    },
    -- cmd+click to open links
    {
        event={Up={streak=1, button="Left"}},
        mods="CMD",
        action=wezterm.action.OpenLinkAtMouseCursor,
    },
},
}