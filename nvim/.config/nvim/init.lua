-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- manually add clangd
if vim.fn.hostname() == "rts" then
  require("lspconfig").clangd.setup({})
  require("notify")("Loaded clangd")
end
