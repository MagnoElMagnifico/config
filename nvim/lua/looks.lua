return {
  ---- COLORSCHEMES -----------------------------------------------------------
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    -- dark, darker, cool, deep, warm, warmer, light
    opts = { style = 'dark' }
  },

   -- :colorscheme drakula, drakula-soft
  {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
  },

  -- :colorscheme sonokai
  {
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    config = function()
      -- default, atlantis, andromeda, shusia, maia, espresso
      vim.g.sonokai_style = 'atlantis'
      vim.g.sonokai_enable_italic = true
    end
  },

  -- :colorscheme tokyonight
  -- :colorscheme tokyonight-night
  -- :colorscheme tokyonight-storm
  -- :colorscheme tokyonight-day
  -- :colorscheme tokyonight-moon
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },

  ---- OTHER VISUAL EFECTS ----------------------------------------------------
  -- Render indentation lines
  {
    'lukas-reineke/indent-blankline.nvim',

    lazy = true,
    event = 'BufEnter',

    main = 'ibl',
    opts = {},
  },

  -- Highlight specific comments:
  --   TODO:
  --   FIX: FIXME, ISSUE, BUG
  --   WARN: WARNING
  --   TEST: TESTING
  --   HACK: DONTFIX
  --   PERF: OPTIM, PERFORMANCE, OPTIMIZE
  --   NOTE: INFO
  --
  -- Also adds the following commands to easily jump to them:
  --
  --  :TodoTelescope  Open in Telescope
  --  :TodoQuickFix   Open in a quickfix window
  --  :TodoLocFix     Open in a location list
  --
  -- With the arguments:
  --
  --  cwd       Directory where to search
  --  keywords  Comma-separated list of types (FIX, TODO, HACK...)
  --
  {
    'folke/todo-comments.nvim',

    lazy = true,
    event = 'BufEnter',

    dependencies = { 'nvim-lua/plenary.nvim' },

    opts = {
      signs = false,
      highlight = { multiline = false },
      search = { pattern = [[\b(KEYWORDS)(\(.*\))?:]] },
      -- Default colors: error, warning, info, hint, default, test
      keywords = {
        TODO = { color = 'info' },
        FIX  = { color = 'error',   alt = { 'FIXME', 'ISSUE', 'BUG' } },
        WARN = { color = 'warning', alt = { 'WARNING' } },
        TEST = { color = 'test',    alt = { 'TESTING' } },
        HACK = { color = 'hint',    alt = { 'DONTFIX' } },
        PERF = { color = 'hint',    alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { color = 'hint',    alt = { 'INFO' } },
      },
    },

    config = function(_, opts)
      require('todo-comments').setup(opts)

      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next TODO comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous TODO comment" })

    end
  },

} -- return
