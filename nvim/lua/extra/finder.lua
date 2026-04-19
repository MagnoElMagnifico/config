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
-- MAPPINGS (inside search UI):
--    <F1>    Help
--    <F2>    Toggle fullscreen
--    <F3>    Toggle wrap lines in preview
--    <F4>    Toggle preview
--    <F5>    Cycle windows
--
--    <A-i>   Toggle ignore
--    <A-h>   Toggle hidden
--
--    <A-g>   Select first
--    <A-G>   Select last
--    <C-f>   Select forward in list
--    <C-b>   Select backward in list
--    <A-S-Up>   Scroll preview
--    <A-S-Down> Scroll preview
--    <C-e>   End of line
--    <C-a>   Start of line
--
--    <C-s>   Open in horizontal split
--    <C-v>   Open in vertical split
--    <C-t>   Open in tab
--

local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
    vim.notify('fzf-lua not available', vim.log.levels.WARN)
    return
end

-- Default configuration
fzf.setup({})

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

