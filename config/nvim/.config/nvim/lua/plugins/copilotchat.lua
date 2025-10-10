local beastmode_path = vim.fn.stdpath("config") .. "/beastmode/beastmode3.1.chatmode.md"
local beastmode_prompt = ""

local file = io.open(beastmode_path, "r")
if file then
  beastmode_prompt = file:read("*all")
  file:close()
end

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function()
      -- Read the beastmode file
      return {
        question_header = "## Me ",
        answer_header = "## Copilot (claude 4.5 sonnet) ",
        error_header = "## Error ",
        model = "claude-sonnet-4.5",
        prompts = {
          Beastmode = {
            prompt = "> ",
            system_prompt = beastmode_prompt,
          },
        },
      }
    end,
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
