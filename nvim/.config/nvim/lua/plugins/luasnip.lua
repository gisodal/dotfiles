return {
  "L3MON4D3/LuaSnip",
  lazy = false,
  --T::
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  dependencies = {
    -- {
    --   "rafamadriz/friendly-snippets",
    --   config = function()
    --     require("luasnip.loaders.from_vscode").lazy_load()
    --   end,
    -- },
    {
      "nvim-cmp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
      },
      opts = function(_, opts)
        opts.snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        }
        table.insert(opts.sources, { name = "luasnip" })
      end,
    },
  },
  build = "make install_jsregexp",
  config = function()
    local snippet_dir = vim.fn.stdpath("config") .. "/user/snippets/"

    require("notify")("load snippets: " .. snippet_dir)
    require("luasnip.loaders.from_lua").lazy_load({ paths = { snippet_dir } })
  end,
}
