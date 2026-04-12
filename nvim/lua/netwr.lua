local function map(mode, mapping, mapped, desc)
  vim.keymap.set(mode, mapping, mapped, { desc = desc, silent = true })
end

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
map('n', '<Leader>ee', vim.cmd.Explore,  'Launch Explorer')
map('n', '<Leader>ev', vim.cmd.Lexplore, 'Toggle Explorer in new Vertical split')
map('n', '<Leader>et', vim.cmd.Texplore, 'Launch Explorer in new Tab')

map(
  'n',
  '<Leader>ec',
  function()
    vim.cmd('Explore ' .. vim.fn.getcwd())
  end,
  'Launch Explorer in CWD'
)
