local Merge_table_into = require("config.custom.functions").Merge_table_into
local fzf = require("fzf-lua")
return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    opts = function(_, opts)
      opts.files = opts.files or {}
      opts.files.rg_opts = (opts.files.rg_opts or "")
        .. " --follow --hidden --glob '!**/.git/*' --glob '!**/node_modules/*' --smart-case"
      opts.files.fd_opts = (opts.files.fd_opts or "") .. " --exclude .git --exclude node_modules"

      Merge_table_into(opts, {
        oldfiles = {
          -- by default buffers visited in the current session are not included.           include_current_session = true,
        },
        previewers = {
          builtin = {
            -- With this change, the previewer will not add syntax highlighting to files larger than 100KB
            syntax_limit_b = 1024 * 100, -- 100KB
          },
        },
        grep = {
          -- One thing I missed from Telescope was the ability to live_grep and the
          -- run a filter on the filenames.
          -- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
          -- With this change, I can sort of get the same behaviour in live_grep.
          -- ex: > enable --*/plugins/*
          -- I still find this a bit cumbersome. There's probably a better way of doing this.
          rg_glob = true, -- enable glob parsing
          glob_flag = "--iglob", -- case insensitive globs
          glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
        },
      })
    end,
    keys = {
      {
        "<leader>;",
        fzf.resume,
        desc = "Resume picker",
      },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      {
        "<leader><",
        LazyVim.pick("oldfiles", { cwd = vim.uv.cwd(), include_current_session = true, only_cwd = true }),
        desc = "Recent (cwd)",
      },
    },
  },
}
