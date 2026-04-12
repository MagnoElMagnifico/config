-- Line numbers and rulers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1' -- Show 1 char for signs next to the numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.colorcolumn = {100} -- Vertical line at 100 characters

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2

-- Search
vim.opt.smartcase = true -- Search case insensitive, unless searching uppercase
vim.opt.ignorecase = true -- Required for 'smartcase' to work
vim.opt.incsearch = true -- Update search live
vim.opt.inccommand = 'nosplit' -- Show in the current window, no previews
vim.opt.hlsearch = true -- Highlight matches

-- Window settings
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Wrap
vim.opt.wrap = true
vim.opt.breakindent = true -- Keep indendation in wrapped lines
vim.opt.showbreak = '\\' -- Show this character when a line is wrapped
vim.opt.smoothscroll = true -- Scroll line-wise even if wrapped

-- Whitespace
vim.opt.list = true
vim.opt.listchars = {
  tab   = '> ', -- Tabs rendered as '>' when they start
  trail = '·',  -- Trailing spaces
  nbsp  = '␣',  -- Non breaking spaces
}

-- Folding
vim.opt.foldmethod = 'expr' -- or marker: using '{{{' and '}}}'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldcolumn = '0' -- No columns in gutter for folds ('auto' to show)
vim.opt.foldtext = '' -- Text to show on folded sections
vim.opt.foldlevel = 99 -- No folds closed by default (set to 0 to close all)
vim.opt.foldnestmax = 4 -- Max fold nesting

-- TODO: disable wrapping, encourage semantic line breaks
-- Formatting options
vim.opt.textwidth = 100
-- t  Autowrap on textwidth
-- c  Wrap comments
-- r  Inside comments, '<Enter>' inserts a new comment
-- o  Same as before, but with 'o' command
-- /  When 'o', don't insert comment if it's not the whole line
-- q  Formatting comments
-- n  Recognize numbered lists ('formatlistpat')
-- l  Don't format longer lines
-- j  Remove comment leader when joining lines
vim.o.formatoptions = 'tcro/qnlj'

-- TODO: ???
-- %n Buffer number
-- %< Truncate text here if no there isn't enough space
-- %f Filename
-- %h [Help]
-- %q [Quickfix List] or [Location List]
-- %w [Preview]
-- %r [RO]
-- %m [+] (unsaved changes) or [-] (modificable off)
-- %= Separator
-- %l,%c-%V Position inside de file
-- %P Percentaje inside the file
vim.opt.statusline = '[%n] %<%f %h%q%w%r%m%=%-14.(%l,%c%V%) %P'
vim.opt.showmode = false -- Current mode will be in the status line


-- Files
vim.opt.fileencoding = 'UTF-8' -- Use UTF-8 always
vim.opt.spelllang = {'es', 'en'} -- Vocabulary check in Spanish and English
vim.opt.autoread = true -- Reload buffer with new changes on disk
vim.opt.undofile = true -- Keep undo history after restart

-- Visuals
vim.opt.termguicolors = true -- 24 bit colors
vim.opt.synmaxcol = 200 -- Syntax highlighting column limit
vim.opt.conceallevel = 0 -- Markup: 1 replace with whitespace, 2 hides it, 0 disables it
vim.opt.concealcursor = ''
vim.opt.winborder = 'rounded'

-- Miscelaneous Quality of Life
vim.opt.mouse = 'a' -- Enable mouse
vim.opt.confirm = true -- Ask to save before quitting
vim.opt.backspace = {'indent', 'eol', 'start', 'nostop'} -- No limitations to backspace
vim.opt.completeopt = {'fuzzy', 'noinsert', 'menu', 'menuone'} -- Completion options
vim.opt.wildoptions:append { 'fuzzy' } -- Wildcard options
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case' -- NOTE: requires ripgrep
