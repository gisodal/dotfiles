-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.scrolloff = 10
opt.sidescrolloff = 10

-- disable all folding
opt.foldenable = false
opt.diffopt = opt.diffopt + "context:99999"

require("config.custom.whitespace")
require("config.custom.diffcolors")

-- disable lsp log
vim.lsp.set_log_level("off")
-- vim.lsp.set_log_level("debug")
