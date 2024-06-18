-- add a new property called my_prop to the properties table
-- usage:
--
-- [*]
-- my_prop = abc
--
require("editorconfig").properties.my_prop = function(bufnr, val, opts)
    -- function arguments:
    -- bufnr: the number of the current buffer
    -- val: the value that was set in the .editorconfig file
    -- opts: a table containing all properties and values set in the .editorconfig file

    -- any logic can be implemented in this function

    -- for example
    -- optional logic can determine whether this value should be set
    if opts.charset and opts.charset ~= "utf-8" then
        -- return without setting the value
        return
    end

    -- perform conditional logic based on val
    if val == "abc" then
        -- set Neovim configuration for the current buffer
        vim.b[bufnr].foo = true
    elseif val == "xyz" then
        -- we can even conditionally create a keymap
        vim.keymap.set("n", "lhs", function()
            -- implement keymap behavior
        end)
    else
        vim.b[bufnr].foo = false
    end
end
