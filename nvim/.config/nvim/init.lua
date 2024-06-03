-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- manually add clangd
-- see docs at https://github.com/neovim/nvim-lspconfig/blob/master/doc/lspconfig.txt
if vim.fn.hostname() == "rts" then
  require("lspconfig").clangd.setup({})
  require("notify")("Loaded clangd")
end
