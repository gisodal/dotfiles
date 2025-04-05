return {
  "stevearc/aerial.nvim",
  opts = function()
    local opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      layout = {
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },

        default_direction = "right",

        placement = "window",

        -- When the symbols change, resize the aerial window (within min/max constraints) to fit
        resize_to_content = false,

        -- Preserve window size equality with (:help CTRL-W_=)
        preserve_equality = false,
        max_width = { 100, 0.5 },
        width = nil,
        min_width = 60,
      },
      float = {
        relative = "editor",
        override = function(conf)
          local padding = 4
          conf.anchor = "NE"
          conf.row = padding
          conf.col = vim.o.columns - padding
          return conf
        end,
      },
    }
    return opts
  end,
}
