-- enable luasnip in blink.cmp
return {
  "saghen/blink.cmp",
  version = "*",
  -- !Important! Make sure you're using the latest release of LuaSnip
  -- `main` does not work at the moment
  dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
  opts = {
    snippets = { preset = "luasnip" },
    -- ensure you have the `snippets` source (enabled by default)
    sources = {
      default = { "snippets", "lsp", "path", "buffer" },
      providers = {
        snippets = {
          min_keyword_length = 2,
          score_offset = 4,
        },
        lsp = {
          min_keyword_length = 3,
          score_offset = 3,
        },
        path = {
          min_keyword_length = 3,
          score_offset = 2,
        },
        buffer = {
          min_keyword_length = 5,
          score_offset = 1,
        },
      },
    },
    keymap = {
      preset = "default", -- disable 'enter' as completion selection key
    },
  },
}
