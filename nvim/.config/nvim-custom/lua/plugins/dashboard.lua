return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	lazy = false,
	config = function()
		local banner = {
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
		}

		local conf = {
			theme = "hyper",

			config = {
				header = banner,
				week_header = {
					enable = false,
				},

				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = " dotfiles",
						group = "Number",
						action = function()
							local builtin = require("telescope.builtin")
							builtin.find_files({ cwd = vim.fn.stdpath("config") })
						end,
						key = "d",
					},
				},
			},
		}

		require("dashboard").setup(conf)
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
