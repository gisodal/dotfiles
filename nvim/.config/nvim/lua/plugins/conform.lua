local merge = require("config.custom.functions").Merge_tables

return {
  "stevearc/conform.nvim",
  --opts = {
  --  formatters_by_ft = {
  --    go = { "gofmt" },
  --  },
  --},

  opts = function(_, opts)
    local local_opts = {
      formatters_by_ft = {
        go = { "/snap/bin/gofmt" },
      },
    }

    return merge(opts, local_opts)
  end,
}
