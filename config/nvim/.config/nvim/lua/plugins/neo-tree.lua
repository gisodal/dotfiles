return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function()
    local explorer = require("config.custom.file_explorer")
    return {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".vscode",
          },
          never_show = { ".git", ".DS_Store", "thumbs.db", ".nx", ".cache", "node_modules" },
        },
      },
      window = {
        width = explorer.DEFAULT_WIDTH,
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
    }
  end,
}
