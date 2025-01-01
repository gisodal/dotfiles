-- show whitespaces, red trailing whitespace, and tabs
local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_set_hl = api.nvim_set_hl

opt.list = true

-- visualize spaces and tabs
local space = "·"
opt.listchars:append({
  tab = "·┈",
  multispace = space,
  lead = space,
  trail = space,
  extends = "▶",
  precedes = "◀",
  nbsp = "‿",
  -- eol = "⏎"
})

-- trailing whitespaces become red
_G.whitespace_enabled = true
cmd([[match TrailingWhitespace /\s\+$/]])
nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })

nvim_create_autocmd("InsertEnter", {
  callback = function()
    opt.listchars.trail = nil
    nvim_set_hl(0, "TrailingWhitespace", { link = "Whitespace" })
  end,
})

nvim_create_autocmd("InsertLeave", {
  callback = function()
    opt.listchars.trail = space
    nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })
  end,
})

local M = {}

function M.toggle_whitespace()
  local opt = vim.opt
  if opt.list:get() then
    opt.list = false
    vim.cmd([[match none]])
  else
    opt.list = true
    vim.cmd([[match TrailingWhitespace /\s\+$/]])
  end
end

return M
