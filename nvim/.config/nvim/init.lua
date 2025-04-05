-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- manually add clangd
-- see docs at https://github.com/neovim/nvim-lspconfig/blob/master/doc/lspconfig.txt
-- see clangd options at : https://manpages.debian.org/experimental/clangd-18/clangd-18.1.en.html
-- see lspconfig clangd options at: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/clangd.lua
--

-- Load all Lua files in the config.custom directory
local custom_config_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/config/custom/*.lua", true, true)
for _, file in ipairs(custom_config_files) do
  local module_name = file:match("lua/(.+)%.lua$"):gsub("/", ".")
  require(module_name)
end
