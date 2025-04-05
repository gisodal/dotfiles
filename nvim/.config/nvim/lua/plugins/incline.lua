return {
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    enabled = true,
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      local latte = require("catppuccin.palettes").get_palette("latte")
      local mocha = require("catppuccin.palettes").get_palette("mocha")
      require("incline").setup({
        window = { padding = 0, margin = { vertical = 0, horizontal = 0 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified

          local format_on_save = (vim.g.autoformat == nil or vim.g.autoformat) --
            and (vim.b.autoformat == nil or vim.b.autoformat) --
            and (vim.b[props.buf].autoformat == nil or vim.b[props.buf].autoformat) --
            and (vim.g.disable_autoformat == nil or vim.g.disable_autoformat) --
            and (vim.b.disable_autoformat == nil or vim.b.disable_autoformat) --
            and (vim.b[props.buf].disable_autoformat == nil or vim.b[props.buf].disable_autoformat) --

          local res = {}

          local function get_git_diff()
            local icons = { removed = "", changed = "", added = "" }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { "┊ " })
            end
            return labels
          end

          local function get_diagnostic_label()
            local icons = { error = "", warn = "", info = "", hint = "" }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { "┊ " })
            end
            return label
          end

          -- add git and diagnostic
          table.insert(res, {
            { get_diagnostic_label() },
            { get_git_diff() },
          })

          -- add icon and filename
          table.insert(res, {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, modified and "*" or "", gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = props.focused and latte.yellow or "",
            guifg = props.focused and helpers.contrast_color(latte.yellow) or helpers.contrast_color("#44406e"),
          })

          -- add format on save icon
          table.insert(res, {
            { format_on_save and "  " or "", guifg = "#6d8086" }, -- Floppy disk icon
          })

          return res
        end,
      })
    end,
  },
}
