return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "copilot",
    auto_suggestions_provider = "copilot",

    providers = {
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "gpt-4.1",
        timeout = 15000,
        extra_request_body = {
          temperature = 0.1,
          max_tokens = 20000,
        },
      },
      bedrock = {
        endpoint = "https://bedrock-runtime.us-east-1.amazonaws.com",
        region = "us-east-1",
        timeout = 20000,
        extra_request_body = {
          temperature = 0.3,
          max_tokens = 4000,
        },
      },
    },
    mappings = {
      ask = "<leader>av",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      toggle = {
        default = "<leader>at",
        debug = "<leader>ad",
        hint = "<leader>ah",
      },
      diff = {
        ours = "<leader>ao",
        theirs = "<leader>ai",
        both = "<leader>ab",
        next = "]x",
        prev = "[x",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
    },
  },
  build = "make",
  config = function(_, opts)
    require("avante").setup(opts)
    -- Add custom keymap for AvanteClear command
    vim.keymap.set("n", "<leader>aX", "<cmd>AvanteClear<CR>", { desc = "Avante Clear History" })
    -- Add command to check current model
    vim.api.nvim_create_user_command("AvanteModel", function()
      -- Robustly determine current provider and model without assuming internal plugin internals
      local provider = opts and opts.provider
      local model = nil

      -- Helper: scan providers table for first model value
      local function scan_providers()
        if not (opts and opts.providers) then
          return nil, nil
        end
        for name, conf in pairs(opts.providers) do
          if type(conf) == "table" and conf.model and type(conf.model) == "string" then
            return name, conf.model
          end
        end
        return nil, nil
      end

      if provider and opts and opts.providers and type(opts.providers) == "table" then
        local conf = opts.providers[provider]
        if type(conf) == "table" and conf.model then
          model = conf.model
        end
      end

      if not model then
        local scanned_provider, scanned_model = scan_providers()
        provider = provider or scanned_provider
        model = scanned_model
      end

      if not model then
        model = "unknown"
      end

      -- Also show other available providers for debugging purposes
      local available = {}
      if opts and opts.providers and type(opts.providers) == "table" then
        for name, conf in pairs(opts.providers) do
          table.insert(available, name .. (conf.model and ("(" .. conf.model .. ")") or ""))
        end
      end
      local available_str = #available > 0 and table.concat(available, ", ") or "none"
      print("Avante provider: " .. (provider or "(none)") .. ", model: " .. model .. " | available: " .. available_str)
    end, {})
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "giuxtaposition/blink-cmp-copilot",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
