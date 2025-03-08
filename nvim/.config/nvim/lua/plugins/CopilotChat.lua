return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      answer_header = "  Copilot (claude-3.7-sonnet) ",
      model = "claude-3.7-sonnet",

      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
