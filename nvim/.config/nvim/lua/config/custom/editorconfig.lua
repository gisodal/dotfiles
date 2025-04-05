local git_root_path = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

-- Function to add current buffer's relative path to .editorconfig in the Git root
local function add_to_editorconfig()
  -- Check if the Git root was found
  if git_root_path == "" then
    print("Error: Not a git repository (or any of the parent directories)")
    return
  end

  -- Get the relative path of the buffer to the Git root
  local buffer_path = vim.api.nvim_buf_get_name(0)
  local rel_path = string.gsub(buffer_path, git_root_path .. "/", "")

  -- Define the path to the .editorconfig file in the Git root
  local editorconfig_path = git_root_path .. "/.editorconfig"

  -- Check if the .editorconfig file exists
  local file_exists = vim.fn.filereadable(editorconfig_path) == 1

  -- Open the .editorconfig file in append mode, creating it if it does not exist
  local file = io.open(editorconfig_path, "a+")
  if file then
    -- If the file did not exist, add the 'root = true' line
    if not file_exists then
      file:write("root = true\n")
    end

    -- Add the buffer's relative path and autoformat setting
    file:write("\n[" .. rel_path .. "]\nautoformat = false\n")
    file:close()
    print("Added to .editorconfig: " .. rel_path)

    -- Disable autoformat for the current buffer
    vim.b.autoformat = false
  else
    error("Error: Could not open or create .editorconfig")
  end
end

-- Keybinding for <leader>ua
if git_root_path ~= "" then
  local wk = require("which-key")
  wk.add({
    "<leader>uN",
    add_to_editorconfig,
    desc = "Add to .editorconfig",
    mode = "n",
    noremap = true,
    silent = true,
    group = "Add to .editorconfig",
  })
end
