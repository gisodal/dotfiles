return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  opts = function(_, opts)
    local keys = vim.tbl_get(opts, "move", "keys") or {}
    for _, dir in ipairs({
      "goto_next_start",
      "goto_next_end",
      "goto_previous_start",
      "goto_previous_end",
    }) do
      local m = keys[dir]
      if m then
        m["]c"], m["[c"], m["]C"], m["[C"] = nil, nil, nil, nil
      end
    end
  end,
}
