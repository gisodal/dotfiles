local M = {}

M.DEFAULT_WIDTH = 60
M.MAX_WIDTH = 80

-- Width contributions used by the neo-tree backend's synthetic width calculation.
local INDENT_SIZE = 2
local ICON_BUDGET = 4 -- devicon (2) + trailing space + slack
local PANEL_MARGIN = 2 -- trailing slack so the last glyph isn't flush with the window border

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
  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if not ok then
    return nil
  end
  local state = manager.get_state("filesystem")
  if not state or not state.tree then
    return nil
  end

  local tree = state.tree
  local max = 0

  local function visit(node_id)
    local children = tree:get_nodes(node_id)
    for _, node in ipairs(children) do
      local depth = node:get_depth() -- NuiTree: root children are depth 1
      local name = node.name or vim.fs.basename(node:get_id()) or ""
      local width = (depth - 1) * INDENT_SIZE + ICON_BUDGET + vim.fn.strdisplaywidth(name)
      if width > max then
        max = width
      end
      if node:has_children() then
        visit(node:get_id())
      end
    end
  end

  visit(nil) -- nil asks NuiTree for the root-level children

  if max == 0 then
    return nil
  end
  return max + PANEL_MARGIN
end

function backends.diffview(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local max = 0
  for _, line in ipairs(lines) do
    local w = vim.fn.strdisplaywidth(line)
    if w > max then
      max = w
    end
  end
  if max == 0 then
    return nil
  end
  return max + PANEL_MARGIN
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
