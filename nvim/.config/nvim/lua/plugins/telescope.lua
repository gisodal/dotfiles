return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fh", "<cmd>Telescope highlights<cr>", desc = "Find highlights" },
      {
        "<leader>/",
        function()
          local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
          if vim.v.shell_error == 0 then
            require("telescope.builtin").live_grep({ cwd = root })
          else
            require("telescope.builtin").live_grep({ root = true })
          end
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader><space>",
        function()
          local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
          if vim.v.shell_error == 0 then
            require("telescope.builtin").find_files({ cwd = root })
          else
            require("telescope.builtin").find_files({ root = true })
          end
        end,
        desc = "Find File",
      },
      {
        "<leader>;",
        require("telescope.builtin").resume,
        desc = "Resume telescope",
      },
    },
  },
}
