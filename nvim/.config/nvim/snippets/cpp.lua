local comment_line = t({ "//-----------------------------------------------------------------------------", "" })

local ret_filename = function()
  return vim.fs.basename(vim.fn.expand("%"))
end

local header_define_name = function()
  return ret_filename().upper()
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
        filename = f(ret_filename),
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

        #ifndef {define}
        #define {define}

        //-----------------------------------------------------------------------------
        // Included Header Files
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        // Class Definition
        //-----------------------------------------------------------------------------

        #endif // {filename}
      ]],
      {
        name = "Giso Dal",
        filename = f(ret_filename),
        define = f(header_define_name),
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
