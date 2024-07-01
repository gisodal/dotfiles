-- Set colors for diffview for Diff Add color group.
-- See current colors: ':Telescope highlights' and filter on diffview.
-- For how to change highlights, see :h :highlight or :h nvim_set_hl().
vim.cmd([[
  highlight  DiffviewDiffAdd        gui=none  guifg=NONE     guibg=NvimDarkGreen
  highlight  DiffviewDiffText       gui=none  guifg=NONE     guibg=NvimDarkGreen
  highlight  DiffviewDiffDeleteDim  gui=none  guifg=#ba1c1c  guibg=NONE
]])
