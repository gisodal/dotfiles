local fzf = require("fzf-lua")
return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = function(_, opts)
      opts.files = opts.files or {}
      opts.files.rg_opts = (opts.files.rg_opts or "")
        .. " --follow --hidden --glob '!**/.git/*' --glob '!**/node_modules/*' --smart-case"
      opts.files.fd_opts = (opts.files.fd_opts or "") .. " --exclude .git --exclude node_modules"
    end,
    keys = {
      {
        "<leader>;",
        function()
          fzf.files({ resume = true })
        end,
        desc = "Resume picker",
      },
    },
  },
}
