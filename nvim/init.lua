-------------------------------------------------------------------------------
--
-- FEATURES:
--
--     Treesitter    Better highlighting
--     LSP           Go to definition, errors & diagnostics
--     completion    Documentation, faster typing, no typos
--     snippets      Writing faster
--     Fuzzy finder  Jump to files and locations easily
--     Mini.nvim     AI              -- tree-sitter operators
--                   Align, Surround -- automate tedious tasks
--                   Bracketed       -- easy navigation (conflict markers for git)
--                   Files           -- netrw moving and coping is annoying
--                   IndentScope     -- show current scope
--                   Statusline      -- prettier status line
--     Gitsigns      Git status and hunk management
--     GuessIndent   Avoid having to do `:set sw=4 et` every time
--     Colorschemes  Onedark
--
-- TODO:
--
--   - Formatting    Consistent format and avoid tedious tasks
--     The biggest problem is finding the right formatter configuration.
--
-------------------------------------------------------------------------------
--
-- CONFIGURATION RULES:
--
--   - Keep dependencies to a minimum, while keeping a full editing experience.
--   - Use defaults whenever possible, specially for keymaps.
--     Some options may be set explicitly in case they're important
--     or planned to be changed in the future.
--   - No need to list every possible configuration, just change what it needs to be changed.
--     However, important keymaps should be listed as documentation.
--   - Not every command must be mapped to a key, only what I use most frequently.
--     Commands are also fine.
--
-------------------------------------------------------------------------------
-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable builtin plugins
-- See which ones are being loaded with :scriptnames
--vim.g.loaded_tutor_mode_plugin = 1
--vim.g.loaded_zip = 1
--vim.g.loaded_zipPlugin = 1
--vim.g.loaded_tar = 1
--vim.g.loaded_tarPlugin = 1
--vim.g.loaded_gzip = 1

-- Must be set before plugins
vim.g.mapleader = ' '

-------------------------------------------------------------------------------
---- Core options and configuration -------------------------------------------
-------------------------------------------------------------------------------

-- This is modular, comment out what you don't need
require 'options'  -- Most basic settings
require 'keymaps'  -- Basic keybindings
require 'commands' -- General auto-commands and user commands
require 'lsp'      -- Language Server mappings, autocommands and configuration
require 'case_convert'

-------------------------------------------------------------------------------
---- Third party plugins configuration ----------------------------------------
-------------------------------------------------------------------------------

-- TODO: document 'runtimepath' and configuration files

vim.pack.add({
  -- Plugins
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main', build = ':TSUpdate' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- Rewritting for V2

  -- setup.style = dark, darker, cool, deep, warm, warmer, light
  'https://github.com/navarasu/onedark.nvim',

  -- :colorscheme drakula, drakula-soft
  --'https://github.com/Mofiqul/dracula.nvim',
  -- vim.g.sonokai_style = default, atlantis, andromeda, shusia, maia, espresso
  --'https://github.com/sainnhe/sonokai',
  -- :colorscheme tokyonight tokyonight-night tokyonight-storm tokyonight-day tokyonight-moon
  --'https://github.com/folke/tokyonight.nvim',
  --{ src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },

  'https://github.com/otavioschwanck/arrow.nvim',
})

require 'extra.treesitter' -- nvim-treesitter
require 'extra.finder'     -- fzf-lua
require 'extra.completion' -- blink
require 'extra.mini'       -- mini.ai, mini.surround, mini.align, mini.bracketed, mini.files, mini.statusline
require 'extra.git'        -- gitsigns

local ok, guess = pcall(require, 'guess-indent')
if ok then guess.setup() end

local ok, arrow = pcall(require, 'arrow')
if ok then arrow.setup({ show_icons = true, leader_key = '-', buffer_leader_key = 'm' }) end

-------------------------------------------------------------------------------
---- Builtin plugins configuration --------------------------------------------
-------------------------------------------------------------------------------

-- Experimental UI for the command line.
--  - Commands syntax highlighting
--  - Use g< to reopen the output
--  - The window behaves like a normal buffer
local ok, ui2 = pcall(require, 'vim._core.ui2')
if ok then ui2.enable() end

-- Builtin file explorer: don't use if mini.files is available
if package.searchpath('mini.files', package.path) then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
else
  require 'netwr'
end

-- Hides search highlights after 'updatetime' of inactivity
-- or entering Insert Mode.
vim.cmd.packadd 'nohlsearch'

-- TODO: undotree
--vim.cmd.packadd 'undotree'

-- TODO: difftool
--vim.cmd.packadd 'difftool'

-------------------------------------------------------------------------------
---- Color scheme -------------------------------------------------------------
-------------------------------------------------------------------------------
-- Preferred builtin colorchemes:  habamax, sorbet, unokai
-- Third party:                    onedark, drakula, sonokai, tokyonight
-- Light themes:                   tokyonight-day, onelight
local ok, onedark = pcall(require, 'onedark')
if ok then
  onedark.setup({ style = 'dark' })
  onedark.load()
else
  -- fallback
  vim.cmd.colorscheme 'habamax'
end
