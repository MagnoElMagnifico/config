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
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1

-- Must be set before plugins
vim.g.mapleader = ' '



require 'options'
require 'keymaps'
require 'commands'
require 'netwr'
-- TODO: revisar LSPs + comandos

if vim.fn.has('nvim-0.12') == 1 then
  -- Experimental
  -- No me gusta que sea bloqueante, no se puede usar para compilar
  require('vim._core.ui2').enable()
end

-- Treesitter    Better highlighting
-- LSP           Faster navigation, inline errors
-- completion    Documentation, faster typing, no typos
-- snippets      Writing faster
-- Formatting    Consistent format and avoid tedious tasks
-- ToggleTerm    Faster terminal handling
-- Telescope     Jump files easily
-- Try https://github.com/ibhagwan/fzf-lua instead
-- Gitsigns      Git status and hunk management
-- Mini.nvim     AI              -- tree-sitter operators
--               Align, Surround -- automate tedious tasks
--               Bracketed       -- easy navigation (conflict markers for git)
--               Files           -- netrw moving and coping is annoying
--               Statusline      -- prettier status line
--
-- GuessIndent   Avoid having to do `:set sw=4 et` every time
--               Maybe replaceable with .editorconfig
--
-- Looks (opt)   Colorschemes: onedark, drakula, sonokai, tokyonight
--               Todo-comments: highlight special comments
--               Indent-blanklines
--               render-markdown.nvim
--
--
-- :Lazy         ???
-- :Lazy check   Check for updates (git fetch)
-- :Lazy update  Updates all the installed plugins (updates lockfile)
-- :Lazy clean   Delete plugins no longer needed
-- :Lazy restore Goes back to the version of the lockfile
--
-- Plugins are installed in the following directories, so to remove lazy.nvim,
-- you can just delete them.
--
--    data      ~/.local/share/nvim/lazy/
--    state     ~/.local/state/nvim/lazy/
--    lockfile  ~/.config/nvim/lazy-lock.json
--
-- Equivalent????
--
--vim.pack.add {
--  ''
--}

-- TODO: revisar que es esto
-- Ver :h plugins
-- vim.cmd.packadd('cfilter')
-- vim.cmd.packadd('nvim.undotree')
-- vim.cmd.packadd('nvim.difftool')

---- CONFIGURED COLORSCHEME ---------------------------------------------------
-- Preferred builtin colorchemes:  habamax, sorbet, unokai
-- Third party:                    onedark, drakula, sonokai, tokyonight
-- Light themes:                   tokyonight-day, onelight
--vim.cmd.colorscheme 'onedark'

