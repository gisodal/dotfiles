return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        -- visible = true,
        -- show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          ".vscode",
        },
        never_show = { ".git", ".DS_Store", "thumbs.db", ".nx", ".cache", "node_modules" },
      },
    },
    window = {
      mappings = {
        ["g"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()

            if vim.fn.isdirectory(path) == 0 then
              path = vim.fs.dirname(path)
            end

            local fzf = require("fzf-lua")
            fzf.live_grep({ cwd = path })
          end,
          desc = "Grep selected dir",
        },
      },
    },
  },
}
