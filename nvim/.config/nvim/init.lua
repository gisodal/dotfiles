-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- manually add clangd
-- see docs at https://github.com/neovim/nvim-lspconfig/blob/master/doc/lspconfig.txt
-- see clangd options at : https://manpages.debian.org/experimental/clangd-18/clangd-18.1.en.html
-- see lspconfig clangd options at: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/clangd.lua
if vim.fn.hostname() == "rts" then
  local root_files = {
    ".git",
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac", -- AutoTools
  }

  local util = require("lspconfig.util")

  require("lspconfig").clangd.setup({
    cmd = {
      "clangd-18",
      "--background-index",
      "-j=4",
      "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/*g++*,usr/bin/g++,/user/bin/c++",
      "--clang-tidy",
      -- "--clang-tidy-checks=*", -- depricated, use .clang-tidy
      "--all-scopes-completion",
      -- "--cross-file-rename", -- depricated
      "--completion-style=bundled",
      "--function-arg-placeholders",
      "--header-insertion-decorators",
      "--header-insertion=iwyu",
      "--pch-storage=memory",
      "--fallback-style=google",
    },
    on_attach = function(_, bufnr)
      vim.keymap.set(
        "n",
        "<leader>ch",
        "<cmd>ClangdSwitchSourceHeader<cr>",
        { desc = "Switch Source/Header (C/C++)", buffer = bufnr, silent = true }
      )
    end,
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    on_new_config = function(_, root)
      require("notify")("LSP root: " .. root)
    end,
    root_dir = function(fname)
      return vim.fn.getcwd()
      -- return util.root_pattern(unpack(root_files))(fname)
    end,
    -- example 1
    -- root_dir = function(fname)
    --   return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    -- end,
    --
    -- example 2
    -- root_dir = util.root_pattern(".yamllint.yaml", ".git") or vim.fn.getcwd()

    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  })
end
