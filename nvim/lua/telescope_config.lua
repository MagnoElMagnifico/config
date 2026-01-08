return {
  -----------------------------------------------------------------------------
  ---- TELESCOPE --------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Telescope is a fuzzy finder whichs allows to quickly select one option in
  -- a list. This can be used to pick a file to jump to, neovim buffers, etc.
  --
  -- ---- PICKERS (':h telescope.builtin') ----
  -- Operations implemented by Telescope. They include a UI, a finder (generates
  -- results to pick), a prompt (user input that triggers the finder) and
  -- a previewer (preview of context of the selected entry)
  --
  -- 'telescope.builtin' contains a collection of pickers implemented as lua
  -- functions. For a complete list, check its manual.
  --
  --    FILE PICKERS: find_files, git_files, grep_string, live_grep
  --    VIM PICKERS: buffers, oldfiles, commands, quickfix, marks, ...
  --    LSP: lsp_references, lsp_incoming_calls, lsp_outcoming_calls
  --    GIT: git_commits, git_branches, git_status, git_stash
  --    OTHERS: treesitter, builtin
  --
  -- Use '<C-/>' in insert mode and '?' in normal mode to show the keymappings
  -- for the current picker.
  --
  -- ---- THEMES (':h telescope.themes') ----
  -- Common configurations grouped for convenience. 
  --
  --    - Dropdown
  --    - Cursor
  --    - Ivy
  --
  -- ---- LAYOUTS (':h telescope.layout') ----
  -- Positions of the prompt, list of results and previewer UIs.
  --
  --    - horizontal
  --    - vertical
  --    - flex
  --    - center
  --    - cursor
  --
  -- ---- COMMAND (':h telescope.command') ----
  -- The command ':Telescope' can be used to execute all the pickers with all
  -- the configurations:
  --
  --    :Telescope find_files hidden=true cwd=/some/dir
  --    :Telescope buffers theme=dropdown
  --
  -- With the limitation of not having any spaces in the options, as they are
  -- converted into the lua calls.
  --
  -- ---- MORE CONFIG ----
  -- Sorters and Previewers.
  --
  -- ---- LINKS ----
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',

    dependencies = {
      'nvim-lua/plenary.nvim', -- Required

      -- Improve performance with the native fzf program
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1 and vim.fn.executable 'fzf' == 1
        end,
      },
    },

    config = function()
      local telescope = require 'telescope'

      -- Here we can configure each picker.
      -- See ':h telescope.setup()'
      telescope.setup {
        defaults = {
          path_displays = 'smart',
          layout_strategy = 'horizontal',
          layout_config = {
            height = 100,
            width = 400,
            prompt_position = 'bottom',
            preview_cutoff = 40,
          },
        }
      }

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')

      ---- MAPPINGS -----------------------------------------------------------
      -- See ':h telescope.builtin'
      local nmap = function(mapping, mapped, desc)
        vim.keymap.set('n', mapping, mapped, { desc = desc })
      end

      local builtin = require 'telescope.builtin'
      local themes  = require 'telescope.themes'

      -- Must-have for quick navigation
      nmap('<leader>f', builtin.find_files, 'Search and jump to Files')
      -- Must-have for quick navigation
      nmap('<leader>a', function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        })
      end, 'Search and jump to All files')

      nmap('<leader>g', builtin.live_grep,  'Search by Grep and jump to result')
      nmap('<leader>b', builtin.buffers,    'Search and jump to open Buffers')
      nmap('<leader>m', builtin.marks,      'Search and jump to Marks')
      nmap('<leader>r', builtin.registers,  'Search and paste Registers')

      -- Useful
      nmap('<leader>s.', builtin.resume,   'Search Repeat (".")')
      nmap('<leader>ss', builtin.builtin,  'Search other Selectors')

      -- Others
      nmap('<leader>sg', builtin.git_files,   'Search Git files')
      nmap('<leader>st', builtin.treesitter,  'Search Treesitter symbols')
      nmap('<leader>sd', builtin.diagnostics, 'Search Diagnostics')
      nmap('<leader>sh', builtin.help_tags,   'Search Help')
      nmap('<leader>sm', builtin.man_pages,   'Search Man pages')
      nmap('<leader>s:', builtin.commands,    'Search and run Commands')
      nmap('<leader>sk', builtin.keymaps,     'Search Keymaps')
      nmap('<leader>so', builtin.oldfiles,    'Search Old files')

      -- LSP-related pickers are in 'lsp.lua'

      ---- CUSTOM -------------------------------------------------------------
      -- Fuzzy find lines in the current buffer
      nmap('<leader>/', builtin.current_buffer_fuzzy_find, 'Search current buffer')

      -- Fuzzy find lines in all opened buffers
      nmap('<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in open Files',
        }
      end, 'Search in Open Files')

      -- Shortcut for searching Neovim configuration files
      nmap('<leader>sc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, 'Search Config files')

      -- Shortcut for searching in my notes
      nmap('<leader>sn', function()
        builtin.find_files(themes.get_dropdown {
          winblend = 10,
          previewer = false,
          cwd = '~/Notes',
          find_command = { 'fd', '-tf', '-E', '*.pdf' },
          prompt_title = 'Search notes',
        })
      end, 'Search Notes')
    end,
  }, -- telescope
} -- return

