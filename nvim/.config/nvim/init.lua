-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- manually add clangd
-- see docs at https://github.com/neovim/nvim-lspconfig/blob/master/doc/lspconfig.txt
-- see clangd options at : https://manpages.debian.org/experimental/clangd-18/clangd-18.1.en.html
if vim.fn.hostname() == "rts" then
  require("lspconfig").clangd.setup({
	cmd = { "clangd-18",
     "--background-index",
     "-j=4",
     "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/*g++*,usr/bin/g++,/user/bin/c++",
     "--clang-tidy",
     -- "--clang-tidy-checks=*", -- depricated, use .clang-tidy
     "--all-scopes-completion",
     -- "--cross-file-rename", -- depricated
     "--completion-style=bundled",
     "--header-insertion-decorators",
     "--header-insertion=iwyu",
     "--pch-storage=memory",
    },
  })
  -- require("notify")("Loaded clangd")
end

