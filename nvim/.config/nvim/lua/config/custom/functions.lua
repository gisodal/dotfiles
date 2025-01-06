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

function M.Merge_table_into(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        M.Merge_table_into(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function M.Merge_tables(...)
  local result = {}
  for _, tbl in ipairs({ ... }) do
    M.Merge_table_into(result, tbl)
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
