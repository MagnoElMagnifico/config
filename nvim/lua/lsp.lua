-------------------------------------------------------------------------------
---- LANGUAGE SERVER PROTOCOL -------------------------------------------------
-------------------------------------------------------------------------------
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
-- Since Neovim 0.11, the API is easier to use and LSPs can be setup natively
-- with almost no boilerplate code. See below for more information.
--

local enabled_servers = {
  'clangd',
  'zuban',
  -- 'pylsp',
  -- 'ols',
  -- 'rust_analyzer',
}

---- LSP KEYMAPS --------------------------------------------------------------
-- Sets up keymaps for the buffer with an LSP Server attached.
-- These are the default keymaps, see ':h lsp-defaults'.
local function keymaps(buffer, client)

  local function map(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = buffer, desc = 'LSP: ' .. desc })
  end

  local tl = require 'telescope.builtin'

  ---- Actions ----
  map('grn', vim.lsp.buf.rename, 'Rename symbol under cursor')
  map('gra', vim.lsp.buf.code_action, 'Code Action')
  map('gq',  vim.lsp.buf.format, 'Format with LSP')

  ---- Navigation ----
  map('grr', tl.lsp_references,                'Goto References of word under cursor')
  map('gri', tl.lsp_implementations,           'Goto Implementation of word under cursor')
  map('grt', tl.lsp_type_definitions,          'Goto Type definition under cursor')

  map('gd',  tl.lsp_definitions,               'Goto Definition') -- First declaration, to go back use '<C-t>'
  map('gD',  vim.lsp.buf.declaration,          'Goto Declaration') -- Jump to header file (not very used)
  map('gO',  tl.lsp_document_symbols,          'Document symbols')
  map('gW',  tl.lsp_dynamic_workspace_symbols, 'Workspace symbols')

  map('gs',    vim.lsp.buf.signature_help, 'Function Signature')
  map('<C-s>', vim.lsp.buf.signature_help, 'Function Signature', 'i')

  ---- Diagnostics ----
  map('K',          vim.lsp.buf.hover,         'Hover Documentation of symbol under cursor')
  map('gl',         vim.diagnostic.open_float, 'Open diagnostic in a floating window')
  map('<Leader>lt', tl.diagnostics,            'Telescope Quickfix diagnostics')
  map('<leader>ll', vim.diagnostic.setloclist, 'Open all diagnostics in a Location List')

  map('[d', function() vim.diagnostic.jump { count = 1, float = true } end, 'Go to previous Diagnostic message')
  map(']d', function() vim.diagnostic.jump { count =-1, float = true } end, 'Go to next Diagnostic message')

  ---- Other ----
  -- tl.lsp_incoming_calls
  -- tl.lsp_outgoing_calls

  -- Toggle inlay hints in code, if the language server you are using supports
  -- them. This may be unwanted, since they displace some of your code.
  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    map('<Leader>li', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, 'Toggle Inlay Hints')
  end
end

---- COMMANDS -----------------------------------------------------------------
-- Stolen from: https://github.com/neovim/nvim-lspconfig/blob/master/plugin/lspconfig.lua
local function commands(buffer, client)
  ---- LSP INFO ----
  vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', { desc = 'Run checkhealth vim.lsp' })

  ---- LSP LOG ----
  vim.api.nvim_create_user_command('LspLog', function()
      vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename()))
  end, { desc = 'Opens the Nvim LSP client log.' })

  ---- LSP START ----
  vim.api.nvim_create_user_command('LspStart', function(info)
    local servers = info.fargs

    -- Default to enabling all servers matching the filetype of the current buffer.
    -- This assumes that they've been explicitly configured through `vim.lsp.config`,
    -- otherwise they won't be present in the private `vim.lsp.config._configs` table.
    if #servers == 0 then
      local filetype = vim.bo.filetype
      for name, _ in pairs(vim.lsp.config._configs) do
        local filetypes = vim.lsp.config[name].filetypes
        if filetypes and vim.tbl_contains(filetypes, filetype) then
          table.insert(servers, name)
        end
      end
    end

    vim.lsp.enable(servers)
  end, {
    desc = 'Enable and launch a language server',
    nargs = '?',
    complete = function() return enabled_servers end,
  })

  ---- LSP RESTART ----
  vim.api.nvim_create_user_command('LspRestart', function(info)
    local client_names = info.fargs

    -- Default to restarting all active servers
    if #client_names == 0 then
      client_names = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for name in vim.iter(client_names) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
        if info.bang then
          vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
            client:stop(true)
          end)
        end
      end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for name in vim.iter(client_names) do
        vim.schedule_wrap(vim.lsp.enable)(name)
      end
    end)
  end, {
    desc = 'Restart the given client',
    nargs = '?',
    bang = true,
    complete = function(arg)
      return vim
        .iter(vim.lsp.get_clients())
        :map(function(client) return client.name end)
        :filter(function(name) return name:sub(1, #arg) == arg end)
        :totable()
    end,
  })

  ---- LSP STOP ----
  vim.api.nvim_create_user_command('LspStop', function(info)
    local client_names = info.fargs

    -- Default to disabling all servers on current buffer
    if #client_names == 0 then
      client_names = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for name in vim.iter(client_names) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
        if info.bang then
          vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
            client:stop(true)
          end)
        end
      end
    end
  end, {
    desc = 'Disable and stop the given client',
    nargs = '?',
    bang = true,
    complete = function() return enabled_servers end,
  })
end

---- LSP AUTOCOMMANDS ---------------------------------------------------------
local function autocommands(buffer, client)
  -- The following two autocommands are used to highlight references of the word
  -- under your cursor when your cursor rests there for a little while.
  --
  -- See `:help CursorHold` for information about when this is executed.
  --
  -- First, check if this is functionality is provided by the LSP Server.
  if client and client.server_capabilities.documentHighlightProvider then
    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = buffer,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    -- When you move your cursor, the highlights will be cleared.
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = buffer,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
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
end

-- Create the mappings and autocommands when an LSP is attached
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- The new buffer will have these new keymaps, autocommands and commands
    keymaps(event.buf, client)
    autocommands(event.buf, client)
    commands(event.buf, client)

  end,
})

---- DIAGNOSTICS --------------------------------------------------------------
-- These are implemented by 'neovim/nvim-lspconfig'. Since I am using very few
-- servers, I will do them myself. However, this repo is useful as a reference.
--
--    :LspInfo     Status of active and configured servers (alias to checkhealth vim.lsp)
--    :LspLog      Open the LSP logfile
--    :LspRestart  Restarts all the servers
--
-- Diagnostics config ':h vim.diagnostic.Opts'
vim.diagnostic.config {
  update_in_insert = true, -- Update LSP while in insert mode
  virtual_text = true,     -- Show diagnostics in virtual text
  severity_sort = true,    -- List important first
  underline = false,
  float = { source = 'if_many' },
}

---- SERVER CONFIG ------------------------------------------------------------
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

---- Configuration for each LSP server ----
-- C/C++ language server
-- Fedora package: clang-devel
vim.lsp.config['clangd'] = {
  cmd = { 'clangd', '--background-index' },
  filetypes = { 'c', 'cpp' },
  root_markers = { 'Makefile', 'CMakeLists.txt', 'compile_commands.json', 'compile_flags.txt' },
}

-- Python language server
-- This is technically a framework, the functionality is implemented via plugins:
-- - Jedi: autocompletion, go to definition, type inference, static analysis...
--   Written in Python (https://jedi.readthedocs.io/)
-- - Ruff: linter and formatter written in Rust (https://docs.astral.sh/ruff/)
-- Fedora package: python3-lsp-server python-lsp-ruff
-- TODO: remove
vim.lsp.config['pylsp'] = {
  cmd = { 'pylsp', '-v', '--log-file', '/tmp/pylsp.log' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  settings = {
    pylsp = {
      plugins = {
        ruff = { enabled = true, },
        -- disable not installed plugins
        autopep8    = { enabled = false, },
        flake8      = { enabled = false, },
        mccabe      = { enabled = false, },
        pycodestyle = { enabled = false, },
        pydocstyle  = { enabled = false, },
        pyflakes    = { enabled = false, },
        pylint      = { enabled = false, },
        rope        = { enabled = false, },
        yapf        = { enabled = false, },
      },
    },
  },
}

-- Python language server
-- Website: https://zubanls.com/
--
-- Installation:
--    python3 -m venv .venv
--    source .venv/bin/activate
--    pip install --upgrade pip
--    pip install zubanls
-- TODO: Does not work with locally installed libraries (numpy, requests...)
vim.lsp.config['zuban'] = {
  cmd = { '/home/magno/Uni/TavernNet/test/.venv/bin/zuban', 'server' },
  filetypes = { 'python' },
  root_markers = { '.git', 'pyproject.toml', 'setup.py' }
}


--[[ TODO: tinymist for typst
-- Website: https://myriad-dreamin.github.io/tinymist/introduction.html
-- cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist-cli
vim.lsp.config["tinymist"] = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {
        -- ...
    }
}]]


-- Rust language server
-- rustup component add rust-analyzer
vim.lsp.config['rust_analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  -- capabilities = {
  --   experimental = {
  --     serverStatusNotification = true,
  --   }
  -- }
}

-- Odin language server
-- git clone https://github.com/DanielGavin/ols && ./build.sh
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

-- Finally, do a call to 'vim.lsp.enable' with the name of the servers.
vim.lsp.enable(enabled_servers)

