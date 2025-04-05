return {
  { -- don't use ENTER to select the completion
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      -- disable <CR> to select a completion
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
      })
    end,
  },
}
