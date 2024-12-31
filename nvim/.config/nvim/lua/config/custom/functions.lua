--- Perform deep merge on multiple tables based on provided policy.
-- @param policy The policy to use for merging ("force" to overwrite, or "keep" otherwise).
-- @param ... The tables to be merged.
-- @return The merged table.
-- @usage
-- local original_opts = { a = 1, b = { x = 10, y = 20 } }
-- local new_opts = { b = { y = 30, z = 40 }, c = 5 }
-- local merged_opts = merge_tables(original_opts, new_opts)
-- -- merged_opts now contains: { a = 1, b = { x = 10, y = 30, z = 40 }, c = 5 }

local M = {}

function M.Merge_tables(...)
  local function merge(tbl1, tbl2)
    for k, v in pairs(tbl2) do
      if type(v) == "table" and type(tbl1[k]) == "table" then
        tbl1[k] = merge(tbl1[k], v)
      else
        tbl1[k] = v
      end
    end
    return tbl1
  end

  local result = {}
  for _, tbl in ipairs({ ... }) do
    merge(result, tbl)
  end
  return result
end

function M.PrintDevIcons()
  local devicons = require("nvim-web-devicons")
  local home_dir = os.getenv("HOME")
  local output_file = home_dir .. "/icons.txt"

  local file = io.open(output_file, "w")
  if file then
    for name, icon in pairs(devicons.get_icons()) do
      file:write(name .. " " .. icon.icon .. "\n")
    end
    file:close()
    print("Icons written to " .. output_file)
  else
    print("Error: Could not open file for writing.")
  end
end

return M
