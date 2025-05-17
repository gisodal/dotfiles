return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      answer_header = "  Copilot (claude-3.7-sonnet) ",
      model = "claude-3.7-sonnet",
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      -- Check if node is available in PATH
      local node_exists = vim.fn.executable("node") == 1
      if not node_exists then
        return false
      end
      return true
    end,
  },
}
