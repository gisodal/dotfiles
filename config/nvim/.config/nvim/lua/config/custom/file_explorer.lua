local M = {}

M.DEFAULT_WIDTH = 60
M.MAX_WIDTH = 80

-- Width contributions used by the neo-tree backend's synthetic width calculation.
local INDENT_SIZE = 2
local ICON_BUDGET = 4 -- devicon (2) + trailing space + slack

-- [winid] -> prior width (set when panel is fitted, cleared when restored).
local saved_widths = {}

local PANEL_FILETYPES = {
  ["neo-tree"] = "neo_tree",
  ["DiffviewFiles"] = "diffview",
  ["DiffviewFileHistory"] = "diffview",
}

local function find_panel()
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local ft = vim.bo[bufnr].filetype
    local backend = PANEL_FILETYPES[ft]
    if backend then
      return winid, backend
    end
  end
  return nil, nil
end

-- Backends return a target display width, or nil if they can't compute one.
local backends = {}

function backends.neo_tree(winid)
  return nil -- implemented in a later task
end

function backends.diffview(winid)
  return nil -- implemented in a later task
end

local function clamp(n, lo, hi)
  if n < lo then return lo end
  if n > hi then return hi end
  return n
end

function M.toggle_fit()
  local winid, backend_name = find_panel()
  if not winid then
    vim.notify("no file explorer panel open", vim.log.levels.INFO)
    return
  end

  -- Second press: restore.
  if saved_widths[winid] then
    vim.api.nvim_win_set_width(winid, saved_widths[winid])
    saved_widths[winid] = nil
    return
  end

  -- First press: fit.
  local computed = backends[backend_name](winid)
  if not computed then
    vim.notify("no width computed for " .. backend_name, vim.log.levels.WARN)
    return
  end

  local current = vim.api.nvim_win_get_width(winid)
  local target = clamp(computed, current, M.MAX_WIDTH)

  if target == current then
    vim.notify("panel already fits", vim.log.levels.INFO)
    return
  end

  saved_widths[winid] = current
  vim.api.nvim_win_set_width(winid, target)
end

return M
