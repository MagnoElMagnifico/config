-------------------------------------------------------------------------------
---- TREE-SITTER --------------------------------------------------------------
-------------------------------------------------------------------------------
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
--    :TSUpdate [lang]    Update a parser or all the installed ones
--    :TSUninstall {lang} Removes a parser
--    :TSLog              Show messages from previous install/update/uninstall
--
--    :Inspect            Show nodes under cursor
--    :InspectTree        Show the whole grammar tree
--                        In this window, press 'o' to get the query editor.
--
-- REFERENCES
--    TJ DeVries: General explanation     https://youtu.be/09-9LltqWLY
--    TJ DeVries: Instalations & basics   https://youtu.be/MpnjYb-t12A
--    TJ DeVries: Real world example      https://youtu.be/v3o9YaHBM4Q

local ok1, treesitter = pcall(require, 'nvim-treesitter')
local ok2, config     = pcall(require, 'nvim-treesitter.config')
if not ok1 or not ok2 then
  vim.notify('nvim-treesitter not available', vim.log.levels.WARN)
  return
end

treesitter.setup()

---- Auto-install ----
local ensure_installed = {
  'bash', 'c', 'cpp', 'java', 'odin', 'rust', 'python',
  'html', 'markdown', 'typst',
  'lua', 'luadoc',
  'vim', 'vimdoc',
  'diff',
}

local already_installed = config.get_installed()
local parsers_to_install = {}

for _, parser in ipairs(ensure_installed) do
  if not vim.tbl_contains(already_installed, parser) then
    table.insert(parsers_to_install, parser)
  end
end

if #parsers_to_install > 0 then
  treesitter.install(parsers_to_install)
end

---- Start treesitter ----
local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
      vim.treesitter.start(args.buf)
    end
  end,
})
