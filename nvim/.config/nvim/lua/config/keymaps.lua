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
