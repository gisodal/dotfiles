local M = {}

-- Function to read lines from a file
local function read_lines_from_file(file)
  local lines = {}
  local f = io.open(file, "r")
  if not f then
    return lines
  end
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end

-- Function to convert .gitignore-style patterns to Neovim autocommand patterns
local function gitignore_to_nvim_pattern(pattern)
  pattern = pattern:gsub("%.", "\\.")
  pattern = pattern:gsub("%*%*/", "**/")
  pattern = pattern:gsub("%*", "*")
  pattern = pattern:gsub("?", "?")
  return pattern
end

local git_root_path = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

-- Function to add current buffer's relative path to .formatignore in the Git root
function M.add_to_formatignore()
  -- Check if the Git root was found
  if git_root_path == "" then
    print("Error: Not a git repository (or any of the parent directories)")
    return
  end

  -- Get the relative path of the buffer to the Git root
  local buffer_path = vim.api.nvim_buf_get_name(0)
  local rel_path = string.gsub(buffer_path, git_root_path .. "/", "")

  -- Define the path to the .formatignore file in the Git root
  local formatignore_path = git_root_path .. "/.formatignore"

  -- Open the .formatignore file in append mode, creating it if it does not exist
  local file = io.open(formatignore_path, "a+")
  if file then
    file:write(rel_path .. "\n")
    file:close()
    print("Added to .formatignore: " .. rel_path)

    -- disable autoformat for the current buffer
    vim.b.autoformat = false
    -- Update autocommands after adding the file
    M.update_autocommands()
  else
    print("Error: Could not open or create .formatignore")
  end
end

-- Function to update autocommands based on .formatignore file
function M.update_autocommands()
  -- Only proceed if the Git root was found
  if git_root_path == "" then
    return
  end

  -- Path to the file containing the list of filenames
  local formatignore_path = git_root_path .. "/.formatignore"

  -- Read the filenames from the file
  local lines = read_lines_from_file(formatignore_path)

  -- Create an autocommand group
  local augroup = vim.api.nvim_create_augroup("DisableAutoFormatOnSave", { clear = true })

  -- Set up autocommands for each filename pattern
  for _, line in ipairs(lines) do
    -- Ignore comments and empty lines
    if not line:match("^#") and line:match("%S") then
      local pattern = gitignore_to_nvim_pattern(line)
      -- Prepend the Git root directory to relative paths
      pattern = git_root_path .. "/" .. pattern

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = augroup,
        pattern = pattern,
        callback = function()
          print("Autocommand triggered for pattern: ", pattern) -- Debug print
          vim.b.autoformat = false
          vim.api.nvim_echo({ { "Autoformat on save is disabled for this buffer", "WarningMsg" } }, false, {})
        end,
      })
    end
  end
end

-- Initial setup of autocommands
M.update_autocommands()

return M
