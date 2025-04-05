-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- area around the cursor
opt.scrolloff = 10
opt.sidescrolloff = 10

-- disable all folding
opt.foldenable = false
opt.diffopt = opt.diffopt + "context:99999"

-- use the clipboard for all interactions
opt.clipboard = "unnamedplus"

-- disable lsp log
vim.lsp.set_log_level("off")
-- vim.lsp.set_log_level("debug")

-- absolute numbering
vim.opt.relativenumber = false

vim.opt.completeopt = { "menu", "menuone", "popup" }
-- the command:
-- :LazyRoot
-- will show you the available roots that LazyVim detects and you can change the LSP server accordingly.
-- if you want to disable LazyVim's root detection, you can set
-- vim.g.root_spec = { "cwd" }
-- the current default is
-- vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
