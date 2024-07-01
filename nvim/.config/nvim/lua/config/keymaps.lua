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
]])

vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<CR>", { desc = "Git blame" })

-- this does not work when passing it throuhg lazy.nvim keys
vim.keymap.set("n", "<leader>fe", "<cmd>Noice telescope<cr>", { desc = "Find error", silent = true })
