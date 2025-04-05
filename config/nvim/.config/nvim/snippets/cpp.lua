local comment_line = t({ "//-----------------------------------------------------------------------------", "" })

local get_filename = function()
  return vim.fs.basename(vim.fn.expand("%"))
end

local get_defname = function()
  local filename = vim.fs.basename(vim.fn.expand("%"))
  return filename:upper():gsub("%.", "_")
end

local get_headername = function()
  local filename = vim.fs.basename(vim.fn.expand("%"))
  local base = filename:gsub("%.%w+$", "")
  local header_extensions = { ".h", ".hpp" }
  local current_dir = vim.fn.expand("%:p:h")

  -- find in the current directory
  for _, ext in ipairs(header_extensions) do
    local headername = base .. ext
    local headerpath = current_dir .. "/" .. headername

    if vim.fn.glob(headerpath) ~= "" then
      print("found header in : ", headerpath)
      return headername
    end
  end

  -- find it using lsp
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  local result = vim.lsp.buf_request_sync(0, "textDocument/references", params, 1000)

  if result then
    for _, res in pairs(result) do
      for _, ref in pairs(res.result) do
        local uri = ref.uri or ref.targetUri
        local path = vim.uri_to_fname(uri)
        for _, ext in ipairs(header_extensions) do
          if path:match(base .. ext .. "$") then
            print("found header with lsp : ", headerpath)
            return vim.fn.fnamemodify(path, ":t")
          end
        end
      end
    end
  end

  return base .. ".h" -- Default to .h if no header file is found
end

return {
  s("ctrig", t("also loaded!!")),
  s(
    "cdoc",
    fmt(
      [[
         //-----------------------------------------------------------------------------
         // File name: {filename}
         // Author: {name}
         // Creation Date: {date}
         // Copyright: {year}, Bosch Security Systems (ST-CO/ENG2.3)
         //
         // Version History:
         // 1 - Baseline
         //-----------------------------------------------------------------------------
         
         //-----------------------------------------------------------------------------
         // Included Header Files
         //-----------------------------------------------------------------------------
 
         #include "{headername}"

         //-----------------------------------------------------------------------------
         // global variables and defines
         //-----------------------------------------------------------------------------
 
         //-----------------------------------------------------------------------------
         // Constructor/Destructor (if not default)
         //-----------------------------------------------------------------------------
         
         //-----------------------------------------------------------------------------
         // public functions
         //-----------------------------------------------------------------------------
         
         //-----------------------------------------------------------------------------
         // Protected Functions
         //-----------------------------------------------------------------------------
         
         //-----------------------------------------------------------------------------
         // Private Functions
         //-----------------------------------------------------------------------------
      ]],
      {
        name = "Giso Dal",
        filename = f(get_filename),
        headername = f(get_headername),
        date = f(function()
          return vim.fn.strftime("%d/%m/%y")
        end, {}),
        year = f(function()
          return vim.fn.strftime("%Y")
        end, {}),
      }
    )
  ),
  s(
    "hdoc",
    fmt(
      [[
        //-----------------------------------------------------------------------------
        // File name: {filename}
        // Author: {name}
        // Creation Date: {date}
        // Copyright: {year}, Bosch Security Systems (ST-CO/ENG2.3)
        //
        // Version History:
        // 1 - Baseline
        //-----------------------------------------------------------------------------
 
        #ifndef {defname}
        #define {defname}
 
        //-----------------------------------------------------------------------------
        // Included Header Files
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        // Class Definition
        //-----------------------------------------------------------------------------
 
        #endif // {defname}
      ]],
      {
        name = "Giso Dal",
        filename = f(get_filename),
        defname = f(get_defname),
        date = f(function()
          return vim.fn.strftime("%d/%m/%y")
        end, {}),
        year = f(function()
          return vim.fn.strftime("%Y")
        end, {}),
      }
    )
  ),
}
