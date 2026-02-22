return {
  -----------------------------------------------------------------------------
  ---- TREE-SITTER ------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Tree-sitter is a parsing library that generates a tree of some source code.
  -- As a result, Neovim has more information about the code since it
  -- understands how it is structured, so it can provide additional
  -- functionalities. These are provided by this package as different modules:
  -- highlight, incremental_selection, indent (see details below).
  --
  -- (Well, technically, tree-sitter is already implemented in Neovim, and the
  -- purpose of the plugin is to get the queries -how to read the generated
  -- tree-, and the parsers themselves.)
  --
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter, but as separate plugins:
  --
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects:  https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  --      (Implemented in this config with 'mini.ai')
  --
  -- Remember that Neovim has this implemented ('vim.treesitter'), but the
  -- plugin also includes some functions:
  --
  --    - :h nvim-treesitter-utils
  --    - :h nvim-treesitter-functions
  --
  -- COMMANDS
  --    :TSInstall {lang}   Install a new parser
  --    :TSInstallInfo      List of supported languages
  --    :TSUpdate [lang]    Update a parser or all the installed ones
  --    :TSModuleInfo       Show the state of every module (highlight,
  --                        incremental_selection, indent) for every parser
  --    :TSToggle {mod}     Dis/enable modules for the current session
  --    :TSBufToggle {mod}  Dis/enable modules for the current buffer
  --
  --    :Inspect            Show nodes under cursor
  --    :InspectTree        Show the whole grammar tree
  --                        In this window, press 'o' to get the query editor.
  --
  -- REFERENCES
  --    TJ DeVries: General explanation     https://youtu.be/09-9LltqWLY
  --    TJ DeVries: Instalations & basics   https://youtu.be/MpnjYb-t12A
  --    TJ DeVries: Real world example      https://youtu.be/v3o9YaHBM4Q
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- Lazy loading is not supported

    -- 'build' is used to run some command when the plugin is installed/updated.
    -- This is only run then, not every time Neovim starts up.
    build = ':TSUpdate', -- Must update parsers at the same time

    config = function(_, opts)
      local filetypes = {
        'bash', 'c', 'cpp', 'java', 'odin', 'rust', 'python',
        'html', 'markdown', 'typst',
        'lua', 'luadoc',
        'vim', 'vimdoc',
        'diff',
      }

      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = vim.treesitter.start,
      })
    end,
  }, -- treesitter
} -- return
