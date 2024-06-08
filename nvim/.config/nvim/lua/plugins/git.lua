-- NOTE: Show diffs
return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<Leader>gd", "<cmd>DiffviewFileHistory %<CR>", desc = "Diff File" },
      { "<Leader>gv", "<cmd>DiffviewOpen<CR>",          desc = "Diff View" },
    },
    opts = function()
      local actions = require("diffview.actions")
      vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("rafi_diffview", {}),
        pattern = "diffview:///panels/*",
        callback = function()
          vim.opt_local.cursorline = true
          vim.opt_local.winhighlight = "CursorLine:WildMenu"
        end,
      })

      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            { "n", "q",              actions.close },
            { "n", "<Tab>",          actions.select_next_entry },
            { "n", "<S-Tab>",        actions.select_prev_entry },
            { "n", "<LocalLeader>a", actions.focus_files },
            { "n", "<LocalLeader>e", actions.toggle_files },
          },
          file_panel = {
            { "n", "q",              actions.close },
            { "n", "h",              actions.prev_entry },
            { "n", "o",              actions.focus_entry },
            { "n", "gf",             actions.goto_file },
            { "n", "sg",             actions.goto_file_split },
            { "n", "st",             actions.goto_file_tab },
            { "n", "<C-r>",          actions.refresh_files },
            { "n", "<LocalLeader>e", actions.toggle_files },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<CR>" },
            { "n", "o", actions.focus_entry },
            { "n", "O", actions.options },
          },
        },
      }
    end,
  },

  -- -----------------------------------------------------------------------------
  -- -- Git blame visualizer
  -- {
  --   "FabijanZulj/blame.nvim",
  --   cmd = "ToggleBlame",
  --   -- stylua: ignore
  --   keys = {
  --     { '<leader>gb', '<cmd>ToggleBlame virtual<CR>', desc = 'Git blame' },
  --     { '<leader>gB', '<cmd>ToggleBlame window<CR>',  desc = 'Git blame (window)' },
  --   },
  --   opts = {
  --     date_format = "%Y-%m-%d %H:%M",
  --   },
  -- },

  -- -----------------------------------------------------------------------------
  -- -- Reveal the commit messages under the cursor
  -- {
  --   "rhysd/git-messenger.vim",
  --   cmd = "GitMessenger",
  --   keys = {
  --     { "<Leader>gm", "<Plug>(git-messenger)", desc = "Reveal commit under cursor" },
  --   },
  --   init = function()
  --     vim.g.git_messenger_include_diff = "current"
  --     vim.g.git_messenger_no_default_mappings = false
  --     vim.g.git_messenger_floating_win_opts = { border = "rounded" }
  --   end,
  -- },


}
