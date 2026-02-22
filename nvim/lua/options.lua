-- TEST: not sure about these options
vim.opt.completeopt = { 'fuzzy', 'menu', 'menuone', 'popup' }

-- Scroll margins
vim.o.scrolloff     = 10
vim.o.sidescrolloff = 10

-- Show relative line numbers
vim.o.number         = true
vim.o.relativenumber = true
vim.o.signcolumn     = 'yes:1' -- Show 1 char for signs next to the numbers

-- Wrap
vim.o.wrap        = true -- Wrap long lines to fit the screen
vim.o.breakindent = true -- Wrapped lines must follow indentation
vim.o.showbreak   = '\\' -- Show this char when a line is wrapped

-- Search
vim.opt.path:append('**')    -- Search in all subdirectories as well
vim.o.smartcase  = true      -- Search case insensitive, unless searching uppercase
vim.o.ignorecase = true      -- Required for 'smartcase' to work
vim.o.incsearch  = true      -- Show matches while typing
vim.o.hlsearch   = true      -- Highlight matches
vim.o.inccommand = 'nosplit' -- Show substitutions live in the window

-- Visuals
vim.o.winborder     = 'bold' -- Default border style of floating windows
vim.o.termguicolors = true   -- Use 24 bit colors in the terminal
vim.o.lazyredraw    = true   -- Don't update screen while executing macros
vim.o.colorcolumn   = '80'   -- Show ruler at column 80
vim.o.cursorline    = true   -- Show current line
vim.o.conceallevel  = 1      -- 1 show whitespace, 2 hides it, 0 disables it
vim.o.list          = true   -- Show whitespaces
vim.opt.listchars = {
  tab   = '> ', -- Tabs rendered as '>' when they start
  trail = '·',  -- Trailing spaces
  nbsp  = '␣',  -- Non breaking spaces
}

-- Format
vim.o.autoindent = true  -- Keep same indentation on the next line
vim.o.smartindent = true -- C-like indenting

-- To convert back to spaces, just ':set expandtab' and ':retab'.
-- ':retab!' will convert any other spaces to tabs
vim.o.shiftwidth = 4     -- Amount of spaces for indentation
vim.o.expandtab  = false -- '<Tab>' insert tabs, not spaces
vim.o.tabstop    = 4     -- Make tabs render and behave like 4 spaces

vim.o.textwidth   = 80   -- Maximum length of the text
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
-- Include unnumbered lists (with '*' may not work that well)
vim.o.formatlistpat = [[^\s*\(\d\+[\.)]\|[-+*]\)\s\+]]

-- Key behaviour
vim.o.mouse = 'a'                           -- Use mouse in command mode as well
vim.o.backspace = 'indent,eol,start,nostop' -- No limitations to backspace

-- Files
vim.o.fileencoding = 'UTF-8' -- Use UTF-8 always
vim.o.spelllang    = 'es,en' -- Vocabulary check in Spanish and English

vim.o.undofile  = true  -- Keep undo history even after restart
vim.o.autoread  = true  -- Update buffer if file changed on disk
vim.o.autowrite = false -- Don't write to disk automatically
vim.o.hidden    = true  -- Keep buffers loaded even if no window is showing them

-- Window opening
vim.o.splitbelow = true
vim.o.splitright = true

-- Folding
vim.o.foldmethod = 'expr' -- or marker: using '{{{' and '}}}'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.o.foldcolumn = '0' -- No columns in gutter for folds ('auto' to show)
vim.o.foldtext = ''    -- Text to show on folded sections
vim.o.foldlevel = 99   -- No folds closed by default (set to 0 to close all)
vim.o.foldnestmax = 4  -- Max fold nesting

-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable built-in plugins
local disabled_built_ins = {
  "2html_plugin", -- :TOhtml
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
