---- Netrw --------------------------------------------------------------------
-- -   Go to parent directory
-- %   Create file
-- d   Create directory
-- R   Rename or move a file/directory
-- D   Delete the file/directory under cursor
-- i   Cicle listing modes (thin, long, wide and tree)
-- cd  Change cwd to current
-- gh  Toggle hidden files
-- gp  Change permissions
--
-- <Enter>  Open in the current window
-- t        Open in a new tab
-- v        Open in a vertical split
-- o        Open in a horizontal split
-- p        Preview
--
-- More info :h netrw-quickmap and :NetrwSettings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 1 -- Show banner as it shows the current directory
vim.g.netrw_winsize = 20

-- Sort directories first
vim.g.netrw_sort_sequence = '[\\/]$'

-- More mappings :h netrw-quickhelp
vim.keymap.set('n', '<Leader>ee', vim.cmd.Explore,  { desc = 'Launch Explorer', silent = true })
vim.keymap.set('n', '<Leader>ev', vim.cmd.Lexplore, { desc = 'Toggle Explorer in new Vertical split', silent = true })
vim.keymap.set('n', '<Leader>et', vim.cmd.Texplore, { desc = 'Launch Explorer in new Tab', silent = true })
vim.keymap.set(
  'n',
  '<Leader>ew',
  function() vim.cmd.Explore(vim.fn.getcwd()) end,
  { desc = 'Launch Explorer in CWD', silent = true }
)

vim.keymap.set(
  'n',
  '<Leader>ec',
  function() vim.cmd.Explore(vim.fn.stdpath 'config') end,
  { desc = 'Launch Explorer in Config directory', silent = true }
)
