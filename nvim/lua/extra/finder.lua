-------------------------------------------------------------------------------
---- FZF-LUA FUZZY FINDER -----------------------------------------------------
-------------------------------------------------------------------------------
--
-- Help: :h fzf-lua.txt
--
-- DEPENDENCIES:
--  - fzf
--  - fd
--  - rg
--
-- COMMANDS
-- This package provides the following command:
--
--     :FzfLua <subcommand> <option>=<value>
--
--  :FzfLua files    Global picker.
--                   - No prefix ==> files
--                   - $         ==> buffers
--                   - @         ==> LSP symbols in current buffer
--                   - #         ==> LSP symbols in workspace
--
--  :FzfLua files    Find files. Valid arguments: cwd=/path
--
-- TODO: complete documentation
--

local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
    vim.notify('fzf-lua not available', vim.log.levels.WARN)
    return
end

-- Default configuration
fzf.setup({
    keymap = {
      builtin = {
        ['<C-q>']       = 'hide',
        ['<F1>']        = 'toggle-help',

        -- preview
        ['<F2>']        = 'toggle-fullscreen',
        ['<F3>']        = 'toggle-preview',
        ['<F4>']        = 'toggle-preview-cw',       -- cycle windows
        ['<F5>']        = 'toggle-preview-wrap',     -- wrap text in preview
        ['<F6>']        = 'toggle-preview-behavior', -- ???
        ['<F7>']        = 'toggle-preview-ts-ctx',   -- treesitter
        ['<F8>']        = 'preview-ts-ctx-dec',      -- treesitter
        ['<F9>']        = 'preview-ts-ctx-inc',      -- treesitter
        ['<S-Left>']    = 'preview-reset',
        ['<S-Down>']    = 'preview-page-down',
        ['<S-Up>']      = 'preview-page-up',
        ['<C-S-Down>']  = 'preview-down',
        ['<C-S-Up>']    = 'preview-up',
      },
      fzf = {
        ['ctrl-z']      = 'abort',
        ['ctrl-u']      = 'unix-line-discard',
        ['ctrl-f']      = 'half-page-down',
        ['ctrl-b']      = 'half-page-up',
        ['ctrl-a']      = 'beginning-of-line',
        ['ctrl-e']      = 'end-of-line',
        ['ctrl-space']  = 'toggle-all',           -- was alt-a
        ['home']        = 'first',                -- was alt-g
        ['end']         = 'last',                 -- was alt-G
        ['f3']          = 'toggle-preview',
        ['f5']          = 'toggle-preview-wrap',
        ['shift-down']  = 'preview-page-down',
        ['shift-up']    = 'preview-page-up',
      },
    },
    actions = {
      files = {
        ['enter']       = FzfLua.actions.file_edit_or_qf,
        ['ctrl-s']      = FzfLua.actions.file_split,
        ['ctrl-v']      = FzfLua.actions.file_vsplit,
        ['ctrl-t']      = FzfLua.actions.file_tabedit,
        ['ctrl-q']      = FzfLua.actions.file_sel_to_qf,     -- was alt-q
        ['ctrl-l']      = FzfLua.actions.file_sel_to_ll,     -- was alt-Q
        ['f10']         = FzfLua.actions.toggle_ignore,      -- was alt-i
        ['f11']         = FzfLua.actions.toggle_hidden,      -- was alt-h
        ['f12']         = FzfLua.actions.toggle_follow,      -- was alt-f
      },
    },
})

local function nmap(mapping, mapped, desc)
  vim.keymap.set('n', mapping, mapped, { desc = desc, silent = true })
end

-- Basic
nmap('<leader>f', fzf.files,       'Find files')
nmap('<leader>g', fzf.live_grep,   'Live search with Grep')
nmap('<leader>G', fzf.grep,        'Search pattern and then fuzzy find results')
nmap('<leader>b', fzf.buffers,     'Search to open Buffers')
nmap('<leader>m', fzf.marks,       'Search and jump to Marks')
nmap('<leader>r', fzf.registers,   'Search and paste Registers')
nmap('<leader>/', fzf.grep_curbuf, 'Search current buffer')

-- LSP: under <leader>l
nmap('<leader>ll',  fzf.lsp_finder,     'All LSP locations related to the symbol under cursor')
nmap('<leader>lr',  fzf.lsp_references, 'Search LSP references of symbol under cursor')
nmap('<leader>ls',  fzf.lsp_document_symbols, 'Search LSP document symbols') -- file outline
nmap('<leader>lw',  fzf.lsp_live_workspace_symbols, 'Search all LSP symbols')
nmap('<leader>ld',  fzf.lsp_document_diagnostics, 'Search LSP diagnostics')
nmap('<leader>lD',  fzf.lsp_workspace_diagnostics, 'Search LSP workspace diagnostics')

-- Extra: under <leader>s
nmap('<leader>.',  fzf.resume,     'Resume last search')
nmap('<leader>ss', fzf.builtin,    'Search available selectors')
nmap('<leader>sh', fzf.helptags,   'Search Help')
nmap('<leader>sm', fzf.manpages,   'Search Man pages')
nmap('<leader>st', fzf.treesitter, 'Search Treesitter symbols')
nmap('<leader>sd', fzf.diagnostics_workspace, 'Search Diagnostics')
nmap('<leader>sk', fzf.keymaps,    'Search Keymaps')

-- Shortcut for searching Neovim configuration files
nmap('<leader>sc', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, 'Search Config files')
-- Shortcut for searching in my notes
nmap('<leader>sn', function() fzf.files { cwd = '~/notes' } end, 'Search Notes')

