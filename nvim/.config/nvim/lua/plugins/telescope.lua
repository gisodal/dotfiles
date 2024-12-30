local builtin = require("telescope.builtin")

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- {
      --   "<leader>/",
      --   function()
      --     local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
      --     if vim.v.shell_error == 0 then
      --       builtin.live_grep({ cwd = root })
      --     else
      --       builtin.live_grep({ root = true })
      --     end
      --   end,
      --   desc = "Grep (Git Dir)",
      -- },
      -- {
      --   "<leader><space>",
      --   function()
      --     local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
      --     if vim.v.shell_error == 0 then
      --       builtin.find_files({ cwd = root })
      --     else
      --       builtin.find_files({ root = true })
      --     end
      --   end,
      --   desc = "Find File (Git Dir)",
      -- },
      --
      --
      -- config = function()
      --       require("telescope").setup({
      --           defaults = {
      --               mappings = {
      --                   i = {
      --                       ["<C-f>"] = require("telescope.actions").to_fuzzy_refine,
      --                   },
      --               },
      --           },
      --       })
      --       require("telescope").load_extension("fzf")
      --   end
      {
        "<leader>.",
        function()
          builtin.grep_string({
            cwd = vim.loop.cwd(),
            shorten_path = true,
            word_match = "-w",
            only_sort_text = true,
            search = "",
            additional_args = {
              "--follow",
              "--hidden",
              "--glob",
              "!**/.git/*",
              "--glob",
              "!**/node_modules/*",
              "--smart-case",
            },
          })
        end,
        desc = "Fuzzy Grep (cwd)",
      },
      {
        "<leader>/",
        function()
          builtin.live_grep({
            cwd = vim.loop.cwd(),
            additional_args = {
              "--follow",
              "--hidden",
              "--glob",
              "!**/.git/*",
              "--glob",
              "!**/node_modules/*",
              "--smart-case",
            },
          })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader><space>",
        function()
          builtin.find_files({
            cwd = vim.loop.cwd(),
            find_command = {
              "rg",
              "--files",
              "--follow",
              "--hidden",
              "--glob",
              "!**/.git/*",
              "--glob",
              "!**/node_modules/*",
            },
          })
        end,
        desc = "Find File (cwd)",
      },
      {
        "<leader>;",
        builtin.resume,
        desc = "Resume Telescope",
      },
      {
        "<leader>fc",
        function()
          builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "[F]ind [C]onfig",
      },
      {
        "<leader>fs",
        builtin.builtin,
        desc = "[F]ind [S]elect Telescope",
      },
      {
        "<leader>f/",
        function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = "[/] Fuzzily search in current buffer",
      },
      {
        "<leader>sne",
        "<cmd>Noice telescope<cr>",
        desc = "Find [E]rror",
        silent = true,
      },
    },
  },
}
