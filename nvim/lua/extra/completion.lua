local ok, blink = pcall(require, 'blink.cmp')
if not ok then
    vim.notify('blink.cmp not available', vim.log.levels.WARN)
    return
end

blink.setup({
  cmdline = { enabled = true },
  signature = { enabled = true },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      path = {
        opts = {
          get_cwd = function(_)
            return vim.fn.getcwd()
          end
        },
      },
    },
  },

  completion = { menu = { border = 'none' } },

  keymap = {
    preset = 'none',

    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<Tab>'] = { 'select_and_accept', 'fallback' },

    ['<C-c>'] = { 'cancel' },

    ['<C-p>'] = { 'select_prev' },
    ['<C-n>'] = { 'select_next' },

    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

    ['<C-j>'] = { 'snippet_forward' },
    ['<C-k>'] = { 'snippet_backward' },

    ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
  }
})

