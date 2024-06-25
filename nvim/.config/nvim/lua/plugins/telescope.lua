return {
 "nvim-telescope/telescope.nvim",
  keys = function ()
    local grep_from_git_root = function()
    	local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
    	if vim.v.shell_error == 0 then
    		require("telescope.builtin").live_grep({ cwd = root })
    	else
    		require("telescope.builtin").live_grep({root = true})
    	end
    end

    local find_files_from_git_root = function()
    	local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
    	if vim.v.shell_error == 0 then
    		require("telescope.builtin").find_files({cwd = root})
    	else
    		require("telescope.builtin").find_files({root = true})
    	end
    end

    return {
      { "<leader>/", grep_from_git_root, desc = "Grep (Root Dir)" },
      { "<leader><space>", find_files_from_git_root, desc = "Find Files (Root Dir)" }
    }

  end
}

