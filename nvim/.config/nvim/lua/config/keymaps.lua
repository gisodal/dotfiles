-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.cmd([[
  cnoreabbrev hs split

  nnoremap x "_x
  vnoremap x "_x

  nnoremap d "_d
  vnoremap d "_d

  nnoremap D "_D

  nnoremap dd "_dd
  vnoremap dd "_dd

  vnoremap <Esc> "_<Esc>
  vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

  xnoremap p P
]])

-- fix line moving with <esc>+jk
-- https://github.com/LunarVim/LunarVim/issues/1857
vim.keymap.del({ "n", "i", "v" }, "<A-j>")
vim.keymap.del({ "n", "i", "v" }, "<A-k>")

-- add toggle to show and hide whitespaces
local whitespace = require("config.custom.whitespace")
local wk = require("which-key")
wk.add({
  "<leader>u<space>",
  whitespace.toggle_whitespace,
  desc = function()
    return vim.opt.list:get() and "Disable Whitespace" or "Enable Whitespace"
  end,
  mode = "n",
  noremap = true,
  silent = true,
  icon = function()
    return vim.opt.list:get() and { icon = "", color = "green" } or { icon = " ", color = "yellow" }
  end,
})

-- function to store the current buffer if it is modified
local function store_buffer_if_modified()
  if vim.bo.readonly then
    vim.notify("Buffer is readonly", vim.log.levels.WARN)
  elseif vim.bo.modified and vim.bo.filetype ~= "neo-tree" and vim.bo.filetype ~= "aerial" then
    vim.cmd("write")
  else
    vim.notify("Buffer is not modified or is a special buffer", vim.log.levels.INFO)
  end
end

wk.add({
  "<leader><CR>",
  store_buffer_if_modified,
  desc = "Store buffer if modified",
  mode = "n",
  noremap = true,
  silent = true,
  icon = "💾",
})
