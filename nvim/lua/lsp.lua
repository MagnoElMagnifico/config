-------------------------------------------------------------------------------
---- LANGUAGE SERVER PROTOCOL -------------------------------------------------
-------------------------------------------------------------------------------
--
-- LSP (Language Server Protocol) is a protocol that standardizes how editors
-- and language tooling communicate.
--
-- In general, you have a server (a standalone process) running some tool that
-- understands your code and provides features like error reporting,
-- auto-completion, go-to-definition, find-references, and more. This is
-- language-specific, so you'll have different servers for different programming
-- languages.
--
-- However, this server is not part of Neovim itself, so they need to
-- communicate using an agreed-upon protocol in order to display that
-- information to you.
--
-- Since Neovim 0.11+, LSP is built-in and required minimal configuration.
-- Since Neovim 0.12+, native insert-mode auto-completio is also built-in.
--
--
-------------------------------------------------------------------------------
---- MAPPINGS & ACTIONS (default Neovim LSP keymaps) --------------------------
-------------------------------------------------------------------------------
--
---- ACTIONS ------------------------------------------------------------------
--
--   gra      code action: fixes/refactors suggested by LSP     vim.lsp.buf.code_action()
--   grn      rename symbol under cursor across workspace       vim.lsp.buf.rename()
--   grx      code lens: contextual LSP commands                vim.lsp.codelens.run()
-- * gq       format selection or buffer via LSP                vim.lsp.buf.format()
--
-- (*) Active when 'formatexpr' is set to vim.lsp.formatexpr(),
-- which is done automatically on attach for the buffer.
--
--
---- NAVIGATION / INFORMATION -------------------------------------------------
--
--   buffer:K hover information like docs or type info          vim.lsp.buf.hover()
--   gri      go to implementation(s) of symbol                 vim.lsp.buf.implementation()
-- * gd       go to definition                                  vim.lsp.buf.definition()
-- * gD       go to declaration                                 vim.lsp.buf.declaration()
--   grt      go to type definition                             vim.lsp.buf.type_definition()
--   grr      list references to symbol                         vim.lsp.buf.references()
--   gO       document symbols: outline of current file         vim.lsp.buf.document_symbol()
--   gx       open document link                                vim.ui.open(), which handles textDocument/documentLink
--   [NONE]   incoming/outgoing calls                           vim.lsp.buf.incoming_calls()/outgoing_calls()
--
-- (*) Active when 'tagfunc' is set to vim.lsp.tagfunc(),
-- which is done automatically on attach for the buffer.
--
-- When a result has multiple locations, a QuickFix/Location List will be used.
-- Overridde via vim.lsp.handlers.
--
-- Symbol navigation concepts:
--
-- - Definition:      Where a symbol is actually defined
-- - Declaration:     Where a symbol is declared in an interface/forward declaration, header, etc.
-- - Implementation:  Concrete implementation of an interface/abstract method
-- - Type Definition: Where the TYPE of a symbol is defined, like struct/class/type alias
--
--
---- INSERT MODE --------------------------------------------------------------
--
--   <C-s>    signature help: function parameter hints          vim.lsp.buf.signature_help()
-- * <C-x><C-o> LSP completion source                           -
--
-- (*) Active when 'omnifunc' is set to vim.lsp.omnifunc(),
-- which is automatically on attach for the buffer.
-- NOTE: In Neovim 0.12+, native auto-completion can replace omnifunc: vim.o.autocomplete = true
--
--
---- SELECT MODE --------------------------------------------------------------
--
--   an     select outward structural range (Treesitter or LSP fallback)
--   in     select inward structural range (Treesitter or LSP fallback)
--   ]n     select next sibling node
--   [n     select previous sibling node
--
--
-------------------------------------------------------------------------------
---- COMMANDS -----------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- :checkhealth vim.lsp    diagnose LSP setup issues
-- :lsp enable [config]    activates LSP for current and future buffers     vim.lsp.enable()
-- :lsp disable [config]   disable LSP
-- :lsp restart [client]   restart LSP client and server
-- :lsp stop [client]      stops LSP client and server
-- :LspLog                 open LSP client log in new tab
-- :LspInfo                alias to :checkhealth vim.lsp
--
--
-------------------------------------------------------------------------------
---- CONFIG (0.11+ native API) ------------------------------------------------
-------------------------------------------------------------------------------
--
--   vim.lsp.config('name', opts)   define or extend a server config
--   vim.lsp.config['name'] = opts  alternative table assignment form
--   vim.lsp.enable('name')         activate a configured server
--   vim.lsp.enable({'a','b'})      activate multiple servers
--
-- Config files can also be placed in lsp/*.lua and are auto-loaded.
-- Use the LspAttach autocmd for buffer-local customization on attach.
--
-- These configuration options are implemented by 'neovim/nvim-lspconfig'.
-- Since I am using very few servers, I will do them myself at the end of this file.
-- However, this repo is useful as a reference.
--
--
-------------------------------------------------------------------------------
---- OTHER FUNCTIONS ----------------------------------------------------------
-------------------------------------------------------------------------------
--
-- INLAY HINTS
--   vim.lsp.inlay_hint.enable(true)    adds virtual text with extra information (parameter names, type info, etc)
--
-- CLIENT LIFECYCLE
--   vim.lsp.start(config)              start a client manually
--   vim.lsp.status()                   LSP progress info (useful in statuslines)
--
-- WORKSPACE
--   vim.lsp.buf.workspace_symbol()     search workspace symbols
--   vim.lsp.buf.add_workspace_folder()
--   vim.lsp.buf.remove_workspace_folder()
--   vim.lsp.buf.list_workspace_folders()
--
-- HIGHLIGHTING
--   vim.lsp.buf.document_highlight()   highlight all references to symbol under cursor
--   vim.lsp.buf.clear_references()     clear those highlights
-- ==> see function autocomands() later
--
-- FOLDING (set in window options)
--   vim.lsp.foldexpr()     use as: vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
--   vim.lsp.foldtext()     use as: vim.wo.foldtext  = 'v:lua.vim.lsp.foldtext()'

-------------------------------------------------------------------------------
---- CUSTOM BINDINGS ----------------------------------------------------------
-------------------------------------------------------------------------------

local function keymaps(buffer)
    -- I don't like the default behaviour of gd and gD
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition', silent = true, buffer = buffer })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', silent = true, buffer = buffer })
end


-------------------------------------------------------------------------------
---- CUSTOM COMMANDS ----------------------------------------------------------
-------------------------------------------------------------------------------

-- Toggle Inlay Hints
vim.api.nvim_create_user_command('LspHints', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay Hints' })


-- Open LSP client log
vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd.tabnew(vim.lsp.log.get_filename())
  local buf = vim.api.nvim_get_current_buf()

  vim.bo[buf].readonly   = true
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype   = 'log'   -- enables highlight if nvim-treesitter-log or similar is installed
  -- jump to the end since the most recent entries are at the bottom
  vim.cmd.normal('G')
  vim.keymap.set('n', 'q', vim.cmd.bdel, { buffer = buf, silent = true })
end, { desc = 'Opens the Nvim LSP client log.' })


-- Shows information about the servers attached to the current buffer
vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify('No LSP clients attached to this buffer', vim.log.levels.WARN)
    return
  end

  local lines = {}
  for _, client in ipairs(clients) do
    table.insert(lines, '--- ' .. client.name .. ' (id: ' .. client.id .. ') ---')
    table.insert(lines, 'Root:       ' .. (client.root_dir or 'none'))
    table.insert(lines, 'Command:    ' .. table.concat(client.config.cmd or {}, ' '))
    table.insert(lines, 'Filetypes:  ' .. table.concat(client.config.filetypes or {}, ', '))
    table.insert(lines, 'Encoding:   ' .. client.offset_encoding)

    -- which capabilities the server actually supports
    local caps = client.server_capabilities
    local supported = {}
    for cap, val in pairs(caps) do
      if val then table.insert(supported, cap) end
    end
    table.sort(supported)
    table.insert(lines, 'Capabilities:')
    for _, cap in ipairs(supported) do
      table.insert(lines, '  ' .. cap)
    end

    table.insert(lines, '')
  end

  -- open in a scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = 'markdown'
  vim.cmd.split()
  vim.api.nvim_win_set_buf(0, buf)
  vim.keymap.set('n', 'q', vim.cmd.bdel, { buffer = buf, silent = true })
end, { desc = 'Show LSP information for the current buffer' })


-------------------------------------------------------------------------------
---- LSP AUTOCOMMANDS ---------------------------------------------------------
-------------------------------------------------------------------------------

-- Create the mappings and autocommands when an LSP is attached
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Custom buffer-local keymaps
    keymaps(event.buf)

    -- Highlight symbol under cursor.
    -- First, check if this is functionality is provided by the LSP Server.
    if client and client.server_capabilities.documentHighlightProvider then
      -- The following two autocommands are used to highlight references of the word
      -- under your cursor when your cursor rests there for a little while.
      -- See `:help CursorHold`.
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function() vim.lsp.buf.document_highlight() end,
      })

      -- When you move your cursor, the highlights will be cleared.
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function() vim.lsp.buf.clear_references() end,
      })

      -- On exit, clear the references and these autocommands
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})


-------------------------------------------------------------------------------
---- DIAGNOSTICS --------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- The diagnostic framework is independent of LSP: it can receive diagnostics
-- from any source (LSP servers, linters, static analysis tools, etc.).
--
-- The API is split between:
--   PRODUCERS  tools that create and set diagnostics (require a namespace)
--   CONSUMERS  end-users who read and display them (namespace usually optional)
--
-- Severities:
--
--   vim.diagnostic.severity.ERROR   (highest priority)
--   vim.diagnostic.severity.WARN
--   vim.diagnostic.severity.INFO
--   vim.diagnostic.severity.HINT    (lowest priority)
--
-- Functions accepting {severity} support three filter forms:
--
--   Single value:    { severity = sev.WARN }
--   Range:           { severity = { min = sev.WARN } }   (WARN and above)
--                    { severity = { max = sev.INFO } }   (INFO and below)
--   Explicit list:   { severity = { sev.WARN, sev.INFO } }
--
-- Handlers control HOW diagnostics are displayed.
-- Built-in handlers: "virtual_text", "virtual_lines", "signs", "underline"
--
-------------------------------------------------------------------------------
---- MAPPINGS (default Neovim keymaps, set unconditionally on startup) --------
-------------------------------------------------------------------------------
--
--   ]d       jump to next diagnostic in buffer          vim.diagnostic.jump({count=1})
--   [d       jump to previous diagnostic in buffer      vim.diagnostic.jump({count=-1})
--   ]D       jump to last diagnostic in buffer          vim.diagnostic.jump({count=math.huge})
--   [D       jump to first diagnostic in buffer         vim.diagnostic.jump({count=-math.huge})
--   <C-w>d   show diagnostic at cursor in float         vim.diagnostic.open_float()
--   <C-w><C-d>  (same as above)
--
-------------------------------------------------------------------------------
---- FUNCTIONS  ---------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- CONSUMER (reading & displaying):
--
--   vim.diagnostic.jump(opts)             jump by count to specific diagnostic
--   vim.diagnostic.open_float(opts?)      show diagnostics at cursor in a float
--   vim.diagnostic.show(ns?, bufnr?)      refresh display (triggers handlers)
--   vim.diagnostic.hide(ns?, bufnr?)      hide diagnostics without removing them
--   vim.diagnostic.status(bufnr?, opts?)  returns a statusline-friendly string
--   vim.diagnostic.get(bufnr?, opts?)     returns list of vim.Diagnostic objects
--   vim.diagnostic.count(bufnr?, opts?)   returns {[severity]=count} table
--   vim.diagnostic.is_enabled(opts?)      returns true if enabled for buffer/ns
--   vim.diagnostic.get_namespace(ns)      returns namespace metadata table
--   vim.diagnostic.get_namespaces()       returns all namespace metadata
--   vim.diagnostic.setqflist(opts?)       populate quickfix list with diagnostics
--   vim.diagnostic.setloclist(opts?)      populate location list with diagnostics
--
-- PRODUCER FUNCTIONS (creating & managing):
--
--   vim.diagnostic.set(ns, bufnr, diagnostics, opts?) set diagnostics for a buffer/namespace
--   vim.diagnostic.get(bufnr, opts)    (also usable by producers for reads)
--   vim.diagnostic.reset(ns?, bufnr?)  clear diagnostics for namespace/buffer
--   vim.diagnostic.enable(bufnr?, opts?)   enable diagnostics (can filter by ns)


-------------------------------------------------------------------------------
---- DIAGNOSTICS CONFIGURATION ------------------------------------------------
-------------------------------------------------------------------------------

vim.diagnostic.config {
  update_in_insert = true,  -- update LSP while in insert mode
  virtual_text     = true,  -- show text at end of line
  virtual_lines    = false, -- show diagnostic in its own line
  severity_sort    = true,  -- list ERROR first
  underline        = false, -- underline diagnostic range
  float = { border = 'rounded', source = 'if_many' },
  jump  = { float = true }, -- Auto open the float after jumping
}

vim.keymap.set('n', 'grd', vim.diagnostic.setqflist, { desc = 'Open diagnostic Quickfix list', silent = true })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open diagnostic', silent = true })


-------------------------------------------------------------------------------
---- CUSTOM COMMANDS ----------------------------------------------------------
-------------------------------------------------------------------------------

-- Snapshot of the settings for the command
local diag_base_config = vim.diagnostic.config()

-- :Diag none   disable all diagnostics
-- :Diag error  show errors only
-- :Diag warn   show errors + warnings
-- :Diag info   show errors + warnings + info
-- :Diag hint   show all (errors + warnings + info + hints)
-- :Diag all    show all (alias for hint)
local diag_levels = {
  none  = false,
  error = vim.diagnostic.severity.ERROR,
  warn  = vim.diagnostic.severity.WARN,
  info  = vim.diagnostic.severity.INFO,
  hint  = vim.diagnostic.severity.HINT,
  all   = vim.diagnostic.severity.HINT,
}

vim.api.nvim_create_user_command('Diag', function(args)
  local level = args.args
  if diag_levels[level] == false and level ~= 'none' then
    vim.notify('Diag: unknown level "' .. level .. '"', vim.log.levels.ERROR)
    return
  end

  if level == 'none' then
    vim.diagnostic.enable(false)
    return
  end

  vim.diagnostic.enable(true)
  local min = { min = diag_levels[level] }
  local config = vim.deepcopy(diag_base_config)  -- always start from the original

  for _, handler in ipairs({ 'signs', 'virtual_text', 'virtual_lines', 'underline', 'float' }) do
    local existing = config[handler]

    if type(existing) == 'table' then
      existing.severity = min
    elseif existing ~= false then
      config[handler] = { severity = min }
    end
  end

  vim.diagnostic.config(config)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(diag_levels)
  end,
})


-------------------------------------------------------------------------------
---- SERVER CONFIG ------------------------------------------------------------
-------------------------------------------------------------------------------
-- (This is actually the important part)
--
-- Enable the following language servers with additional configuration options.
--
--   cmd          The command that runs the server.
--   filetypes    File types where the server will be launched.
--   capabilities Can be used to disable certain LSP features.
--   settings     Specific configurations options for the server.
--   root_markers How to choose the working directory for project.
--                If the same directory is used, we'll use the same server.
--
-- This generic configuration ('*') will merged for the with the others
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

---- Configuration for each LSP server ----------------------------------------
---- CLANG ----
-- C/C++ language server
-- Fedora package: clang-devel or clang-tools-extra
vim.lsp.config['clangd'] = {
  cmd = { 'clangd', '--background-index' },
  filetypes = { 'c', 'cpp' },
  root_markers = { 'Makefile', 'CMakeLists.txt', 'compile_commands.json', 'compile_flags.txt' },
}

---- ZUBAN ----
-- Python language server
-- Website: https://zubanls.com/
-- Installation: pipx install zubanls
vim.lsp.config['zuban'] = {
  cmd = { 'zuban', 'server' },
  filetypes = { 'python' },
  root_markers = { '.git', 'pyproject.toml', 'setup.py' }
}

---- RUFF ----
-- Python linter
vim.lsp.config['ruff'] = {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  settings = {},
}

---- RUST_ANALYZER ----
-- Rust language server
-- Installation: rustup component add rust-analyzer
vim.lsp.config['rust'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
}

---- OLS ----
-- Odin language server
-- Installation: git clone https://github.com/DanielGavin/ols && ./build.sh
vim.lsp.config['ols'] = {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_markers = { 'ols.json', '.git' },
  settings = {
    init_options = {
      checker_args = { '-vet', '-strict-style' },
      collections = {
        -- { name = 'example', path = vim.fn.expand('$HOME/odin-lib') },
      },
    },
  },
}

---- LANGUAGE TOOL ----
-- LanguageTool (spell and grammar checking)
-- Website: https://ltex-plus.github.io/ltex-plus/index.html
-- Instalation: manually from Github Releases (https://github.com/ltex-plus/ltex-ls-plus/releases)
-- Info: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ltex_plus.lua
vim.lsp.config['languagetool'] = {
  cmd = { 'ltex-ls-plus' },
  filetypes = { 'gitcommit', 'markdown', 'plaintex', 'tex', 'text', 'typst' },
  root_markers = { '.git' },
  settings = {
    ltex = {
      language = 'es', -- en-US
      enabled = { 'gitcommit', 'markdown', 'plaintex', 'tex', 'text', 'typst' },
    },
  },
}

-- Finally, do a call to 'vim.lsp.enable' with the name of the configurations.
vim.lsp.enable({
  'clangd',
  --'zuban',
  'ruff',
  'ols',
  'rust',
})

