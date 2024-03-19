return {
	require("plugins/sleuth"),
	require("plugins/comments"),
	require("plugins/gitsigns"),
	require("plugins/noice"),
	require("plugins/neotree"),
	require("plugins/whichkey"),
	require("plugins/telescope"),
	require("plugins/lsp"),
	require("plugins/conform"),
	require("plugins/cmp"),
	require("plugins/theme"),
	require("plugins/todo_comments"),
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',

	--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = 'custom.plugins' },
}
