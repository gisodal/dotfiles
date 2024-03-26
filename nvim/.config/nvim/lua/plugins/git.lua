-- NOTE: Show diffs
return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<Leader>gd", "<cmd>DiffviewFileHistory %<CR>", desc = "Diff File" },
			{ "<Leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
		},
		opts = function()
			local actions = require("diffview.actions")
			vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
				group = vim.api.nvim_create_augroup("rafi_diffview", {}),
				pattern = "diffview:///panels/*",
				callback = function()
					vim.opt_local.cursorline = true
					vim.opt_local.winhighlight = "CursorLine:WildMenu"
				end,
			})

			return {
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				keymaps = {
					view = {
						{ "n", "q", actions.close },
						{ "n", "<Tab>", actions.select_next_entry },
						{ "n", "<S-Tab>", actions.select_prev_entry },
						{ "n", "<LocalLeader>a", actions.focus_files },
						{ "n", "<LocalLeader>e", actions.toggle_files },
					},
					file_panel = {
						{ "n", "q", actions.close },
						{ "n", "h", actions.prev_entry },
						{ "n", "o", actions.focus_entry },
						{ "n", "gf", actions.goto_file },
						{ "n", "sg", actions.goto_file_split },
						{ "n", "st", actions.goto_file_tab },
						{ "n", "<C-r>", actions.refresh_files },
						{ "n", "<LocalLeader>e", actions.toggle_files },
					},
					file_history_panel = {
						{ "n", "q", "<cmd>DiffviewClose<CR>" },
						{ "n", "o", actions.focus_entry },
						{ "n", "O", actions.options },
					},
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Git blame visualizer
	{
		"FabijanZulj/blame.nvim",
		cmd = "ToggleBlame",
		-- stylua: ignore
		keys = {
			{ '<leader>gb', '<cmd>ToggleBlame virtual<CR>', desc = 'Git blame' },
			{ '<leader>gB', '<cmd>ToggleBlame window<CR>', desc = 'Git blame (window)' },
		},
		opts = {
			date_format = "%Y-%m-%d %H:%M",
		},
	},

	-----------------------------------------------------------------------------
	-- Reveal the commit messages under the cursor
	{
		"rhysd/git-messenger.vim",
		cmd = "GitMessenger",
		keys = {
			{ "<Leader>gm", "<Plug>(git-messenger)", desc = "Reveal commit under cursor" },
		},
		init = function()
			vim.g.git_messenger_include_diff = "current"
			vim.g.git_messenger_no_default_mappings = false
			vim.g.git_messenger_floating_win_opts = { border = "rounded" }
		end,
	},

	-----------------------------------------------------------------------------
	-- Git signs written in pure lua
	{
		"lewis6991/gitsigns.nvim",

		event = { "BufReadPre", "BufNewFile" },
	  -- See: https://github.com/lewis6991/gitsigns.nvim#usage
		-- stylua: ignore
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			attach_to_untracked = true,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			preview_config = {
				border = "rounded",
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				---@return string
				map("n", "]g", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Git hunk forward" })

				map("n", "[g", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Git hunk last" })

				-- Actions
				--
				map("n", "<leader>hs", gs.stage_hunk, { silent = true, desc = "Stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { silent = true, desc = "Reset hunk" })
				map("x", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk" })
				map("x", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk" })
				map("n", "<leader>hS", gs.stage_buffer, { silent = true, desc = "Stage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo staged hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "gs", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "Preview hunk inline" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { desc = "Show blame commit" })
				map("n", "<leader>hd", gs.diffthis, { desc = "Diff against the index" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "Diff against the last commit" })
				map("n", "<leader>hl", function()
					if vim.bo.filetype ~= "qf" then
						require("gitsigns").setqflist(0, { use_location_list = true })
					end
				end, { desc = "Send to location list" })

				-- Toggles
				map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "Toggle Git line blame" })
				map("n", "<leader>htd", gs.toggle_deleted, { desc = "Toggle Git deleted" })
				map("n", "<leader>htw", gs.toggle_word_diff, { desc = "Toggle Git word diff" })
				map("n", "<leader>htl", gs.toggle_linehl, { desc = "Toggle Git line highlight" })
				map("n", "<leader>htn", gs.toggle_numhl, { desc = "Toggle Git number highlight" })
				map("n", "<leader>hts", gs.toggle_signs, { desc = "Toggle Git signs" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { silent = true, desc = "Select hunk" })
			end,
		},
	},
}
