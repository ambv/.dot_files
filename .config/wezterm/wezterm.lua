
local wezterm = require 'wezterm'
local default_prog = {"/opt/homebrew/bin/xonsh", "-l"}
local color_cache = {}
local config = {
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
  tab_max_width = 45,
  colors = {
    foreground = '#e0e0e0',
    background = 'hsl(280, 100%, 3%)',
    tab_bar = {
      background = 'hsl(280, 100%, 11%)',
      active_tab = {
        bg_color = 'hsl(280, 100%, 3% / 0%)',
        fg_color = 'hsl(240, 100%, 100%)',
      },
      inactive_tab = {
        bg_color = 'hsl(280, 100%, 20%)',
        fg_color = 'hsl(280, 67%, 67%)',
      },
      inactive_tab_hover = {
        bg_color = 'hsl(280, 100%, 30%)',
        fg_color = 'hsl(280, 100%, 80%)',
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
    scrollbar_thumb = 'hsl(220, 25%, 33%)',
    split = 'hsl(280, 25%, 11%)',
  },
  background = {
    {
      source = {Color="#010003"},
      height = "100%",
      width = "100%",
    },
    {
      source = {File=wezterm.config_dir .. "/wezterm-background.png"},
      vertical_align = "Bottom",
      horizontal_align = "Left",
      height = "2160px",
      width = "3840px",
      repeat_x = "Mirror",
      repeat_y = "Mirror",
    },
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
    {key="s", mods="CMD", action=wezterm.action.SendKey{key="s", mods="CTRL"}},
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
  hyperlink_rules = {
    -- the default regex doesn't support port numbers
    {
        regex = "\\b\\w+://(?:[\\w.-]+)\\S*\\b",
        format = "$0",
    },
  },
}

function get_max_cols(window)
  local tab = window:active_tab()
  local cols = tab:get_size().cols
  return cols
end

wezterm.on(
  'window-config-reloaded',
  function(window)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'window-resized',
  function(window, pane)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

-- make the tab titles pretty wide
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local actual_max_w = math.min((wezterm.GLOBAL.cols // #tabs) - 3, config.tab_max_width - 2)
    local title = tab.active_pane.title
    local full_title = (tab.tab_index + 1) .. '. ' .. title

    if #full_title > actual_max_w then
      return " " .. wezterm.truncate_right(full_title, actual_max_w) .. "…"
    elseif #full_title == actual_max_w then
      return " " .. full_title .. " "
    end

    local lpad = 2 + actual_max_w - #full_title
    local rpad = 0
    if math.fmod(lpad, 2) == 1 then
      lpad = lpad // 2
      rpad = lpad + 1
    else
      lpad = lpad // 2
      rpad = lpad
    end
    return string.rep(' ', lpad) .. full_title .. string.rep(' ', rpad)
  end
)

function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

-- make the scrollbar transparent when not needed
wezterm.on("update-status", function(window, pane)
  local overrides = window:get_config_overrides() or {}

  -- the caching dance is necessary because overrides are per window,
  -- not per pane, and more importantly, there seems to be some bug
  -- that makes all colors revert to default until the color override
  -- table is complete.
  if color_cache[window] then
    if color_cache[window][pane] then
      overrides.colors = color_cache[window][pane]
    else
      overrides.colors = copy(config.colors)
      color_cache[window][pane] = overrides.colors
    end
  else
    overrides.colors = copy(config.colors)
    color_cache[window] = {
      [pane] = overrides.colors
    }
  end

  local dim = pane:get_dimensions()
  if pane:is_alt_screen_active() then
    overrides.colors.scrollbar_thumb = "transparent"
  else
    local rate = 2 * dim.scrollback_rows / dim.viewport_rows
    rate = math.floor(math.min(100, rate))
    overrides.colors.scrollbar_thumb = 'hsl(220, 25%, 33% / ' .. rate .. '%)'
  end
  window:set_config_overrides(overrides)
end)

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window({args = {"/opt/homebrew/bin/bpytop"}})
  window:gui_window():maximize()
  wezterm.GLOBAL.cols = get_max_cols(window)
  window:spawn_tab {}
end)

return config
