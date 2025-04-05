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

      -- Custom prompts
      prompts = {
        DocCheck = {
          prompt = "Review the code and identify any inconsistencies between the implementation and its documentation/comments. Point out where the documentation is missing, outdated, or incorrect relative to the actual code behavior. Format your response as a list of issues with specific line references.",
          strategy = "prompt",
        },
      },

      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
