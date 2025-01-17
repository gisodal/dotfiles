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
    },
  },
}
