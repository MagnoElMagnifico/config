-- Modes
--   n    Normal
--   i    Insert
--   c    Command (Ex command)
--   v    Visual and Select (x: Visual, s: Select)
--   t    Terminal (insert mode inside of a terminal)
--   o    Operator pending
local function map(mode, mapping, mapped, desc)
  vim.keymap.set(mode, mapping, mapped, { desc = desc, silent = true })
end

-- Changes because of the keyboard layout
map({'n', 'v', 'o'}, ',', ';', 'Repeat f, F, t, T')
map({'n', 'v', 'o'}, ';', ',', 'Repeat f, F, t, T in the opposite direction')

---- Convenient keymaps ----
map('n', 'U', '<C-R>', 'Redo')
map('v', 'p', 'P', "Don't overwrite yanked text with the selected content")
map('n', 'gV', '`[v`]', 'Select pasted text') -- analogous to gv

map('n', '<Esc>', '<cmd>nohlsearch<Enter>', 'Clear highlightings')
map('t', '<Esc>', '<C-\\><C-n>', 'Exit terminal')

-- Stay in visual mode after indenting
map('v', '<', '<gv', 'Unintend selection')
map('v', '>', '>gv', 'Indent selection')

---- Window commands ----
map({'n', 'v'}, 'ñ', '<C-w>', 'Window command') -- On a US keyboard this would be ';'
map({'n', 'v'}, 'Ñ', '<C-w>', 'Window command')
map({'n', 'v'}, '<C-h>', '<C-w>h', 'Jump one window left')
map({'n', 'v'}, '<C-l>', '<C-w>l', 'Jump one window right')
map({'n', 'v'}, '<C-j>', '<C-w>j', 'Jump one window down')
map({'n', 'v'}, '<C-k>', '<C-w>k', 'Jump one window up')

map({'n', 'v'}, 'go', '<C-^>', 'Alternate file') -- Similar to 'gt'

-- Tabs (I don't use them very often)
map({'n', 'v'}, '<C-.>',     'g<Tab>',            'Jump to the last accessed tab')
map({'n', 'v'}, '<C-Right>', vim.cmd.tabnext,     'Jump to the next tab')
map({'n', 'v'}, '<C-Left>',  vim.cmd.tabprevious, 'Jump to the previous tab')
for i = 1, 9 do
  map({'n', 'v'}, '<C-' .. i .. '>', i .. 'gt', 'Jump to tab number ' .. i)
end

---- Centering cursor ----
-- Center cursor in the screen while searching
map({'n', 'v'}, 'n', 'nzz', 'Next search match')
map({'n', 'v'}, 'N', 'Nzz', 'Previous search match')

local function keepjumps(cmd)
  return '<cmd>keepjumps normal! ' .. cmd .. '<Enter>'
end

-- Make the bottom line be the centered one
-- map({'n', 'v'}, '<C-d>', keepjumps('M<C-d>zz'), 'Scroll down half a screen')
-- -- Make the top line be the centered one
-- map({'n', 'v'}, '<C-u>', keepjumps('M<C-u>zz'), 'Scroll up half a screen')
-- -- Make the bottom line the top one
-- map({'n', 'v'}, '<C-f>', keepjumps('<C-f><C-e>M'), 'Scroll down a screen')
-- -- Make the top line the bottom one
-- map({'n', 'v'}, '<C-b>', keepjumps('<C-b><C-y>M'), 'Scroll down a screen')

map({'n', 'v'}, '<C-d>', '<C-d>zz', 'Scroll down half a screen')
map({'n', 'v'}, '<C-u>', '<C-u>zz', 'Scroll up half a screen')
map({'n', 'v'}, '<C-f>', '<C-f>zz', 'Scroll down a screen')
map({'n', 'v'}, '<C-b>', '<C-b>zz', 'Scroll down a screen')
map({'n', 'v'}, '<C-o>', '<C-o>zz', 'Go back in the jumplist')
map({'n', 'v'}, '<C-i>', '<C-i>zz', 'Go forward in the jumplist')

-- In my opinion, these commands should not be considered jumps, as they are not
-- that big and easily undoable.
map({'n', 'v'}, '{', keepjumps('{'), 'Jump to previous empty line')
map({'n', 'v'}, '}', keepjumps('}'), 'Jump to next empty line')
map({'n', 'v'}, '(', keepjumps('('), 'Jump to previous sentence')
map({'n', 'v'}, ')', keepjumps(')'), 'Jump to next sentence')
map({'n', 'v'}, 'H', keepjumps('H'), 'Jump to the top of the screen')
map({'n', 'v'}, 'M', keepjumps('M'), 'Jump to middle of the screen')
map({'n', 'v'}, 'L', keepjumps('L'), 'Jump to bottom of the screen')

---- Leader key ----
vim.g.mapleader = ' '
map({'n', 'v'}, '<Space>', '<Nop>', 'Unmap leader key')

-- Yank and Paste from system clipboard
map({'n', 'v'}, '<Leader>p', '"+p', 'Paste from system clipboard')
map({'n', 'v'}, '<Leader>y', '"+y', 'Yank to system clipboard')
map({'n', 'v'}, '<Leader>P', '"+P', 'Paste from system clipboard')
map('n',        '<Leader>Y', '"+y$', 'Yank to system clipboard')
map({'n', 'v'}, '<Leader>d', '"_d', 'Delete without changing the registers')
map({'n', 'v'}, '<Leader>D', '"_D', 'Delete without changing the registers')

map({'n', 'v'}, '<Leader>w', vim.cmd.write, 'Save file')
map({'n', 'v'}, '<Leader>x', '<cmd>confirm bdel<enter>', 'Save file')
map({'n', 'v'}, '<Leader>q', '<cmd>confirm qall<enter>', 'Quit Neovim')

