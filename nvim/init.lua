--
-- CONFIGURATION RULES:
--   - Keep dependencies to a minimum, while keeping a full editing experience:
--
--          Lazy          Automatic installs and updates for plugins
--          >>> Mason         The same for third-party tools (LSPs) <<<
--
--          Treesitter    Better highlighting
--          LSP           Faster navigation, inline errors
--          completion    Documentation, faster typing, no typos
--          snippets      Writing faster
--          Formatting    Consistent format and avoid tedious tasks
--          ToggleTerm    Faster terminal handling
--          Telescope     Jump files easily
--          Gitsigns      Git status and hunk management
--          Mini.nvim     AI              -- tree-sitter operators
--                        Align, Surround -- automate tedious tasks
--                        Bracketed       -- easy navigation (conflict markers for git)
--                        Files           -- netrw moving and coping is annoying
--                        Statusline      -- prettier status line
--
--          GuessIndent   Avoid having to do `:set sw=4 et` every time
--                        Maybe replaceable with .editorconfig
--
--          Looks (opt)   Colorschemes: onedark, drakula, sonokai, tokyonight
--                        Todo-comments: highlight special comments
--                        Indent-blanklines
--                        render-markdown.nvim
--
--   - Use defaults whenever possible, specially for keymaps. Some options may
--     be set explicitly in case they're important or planned to be changed in
--     the future.
--   - No need to list every possible configuration, just change what it needs
--     to be changed. However, important keymaps should be listed as
--     documentation.
--   - Not every command must be mapped to a key, only what I use most
--     frequently.
-------------------------------------------------------------------------------
---- LAZY PACKAGE MANAGER -----------------------------------------------------
-------------------------------------------------------------------------------
-- This plugin allows to manage other plugins automatically.
--
--    :Lazy         Open lazy.nvim menu to check your plugins' status
--                  You can use '?' in this menu for help.
--                  ':q' closes the window.
--    :Lazy check   Check for updates (git fetch)
--    :Lazy update  Updates all the installed plugins (updates lockfile)
--    :Lazy clean   Delete plugins no longer needed
--    :Lazy restore Goes back to the version of the lockfile
--
-- Plugins are installed in the following directories, so to remove lazy.nvim,
-- you can just delete them.
--
--    data      ~/.local/share/nvim/lazy/
--    state     ~/.local/state/nvim/lazy/
--    lockfile  ~/.config/nvim/lazy-lock.json
--
-- Bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath
  }

  if vim.v.shell_error ~= 0 then
    -- Show the error it the previous command was not successful
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim\nError message' },
      { out, 'Warning message' },
      { '\nPress any key to exit...' },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
---- CALL OTHER FILES ---------------------------------------------------------
-------------------------------------------------------------------------------
-- This is modular, comment out what you don't need

-- Builtin configuration
require 'options'  -- Most basic settings
require 'keymaps'  -- Basic keybindings
require 'commands' -- Auto-commands and user commands
--require 'netrw'  -- Netrw configuration (deprecated by mini.files)
require 'lsp'      -- Language Server mappings, autocommands configuration

-- Third party plugins
require('lazy').setup({
  require 'completion',       -- blink
  require 'format',           -- conform
  require 'git',              -- gitsigns, [neogit]
  require 'looks',            -- onedark, dracula, tokyonight, indent-blankline, todo-comments
  require 'mini_config',      -- mini.ai, mini.surround, mini.align, mini.bracketed, mini.files, mini.statusline
  require 'telescope_config', -- telescope, dependencies: {plenary, telescope-fzf-native}
  require 'terminal',         -- toggleterm
  require 'treesitter',       -- nvim-treesitter

  -- Detect tabstop and shiftwidth automatically (alternative to 'tpope/vim-sleuth')
  -- Command ':GuessIndent'
  -- TODO: does not work always
  { 'NMAC427/guess-indent.nvim', event = 'BufEnter',  opts = {} },
})

---- CONFIGURED COLORSCHEME ---------------------------------------------------
-- Preferred builtin colorchemes:  habamax, sorbet, unokai
-- Third party:                    onedark, drakula, sonokai, tokyonight
-- Light themes:                   tokyonight-day, onelight
vim.cmd.colorscheme 'onedark'

