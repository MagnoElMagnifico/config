-------------------------------------------------------------------------------
---- User commands ------------------------------------------------------------
-------------------------------------------------------------------------------

-- Opens update buffer
vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, {desc = 'Update packages'})


-- Deletes packages by name
vim.api.nvim_create_user_command('PackDel', function(opts)
  local names = vim.split(opts.args, '%s+', { trimempty = true })
  if #names == 0 then
    vim.notify('PackDel: no package name provided', vim.log.levels.ERROR)
    return
  end
  vim.pack.del(names)
  vim.notify('Remember to remove them from the configuration as well', vim.log.levels.INFO)
end, {
  desc = 'Delete packages',
  nargs = '+',   -- one or more package names
  complete = function(arglead, cmdline, _)
    -- Build list of installed package names from vim.pack.get()
    local installed = vim.tbl_map(function(p)
      return p.spec.name
    end, vim.pack.get())

    -- Filter by what the user has typed so far
    return vim.tbl_filter(function(name)
      return name:find(arglead, 1, true) ~= nil
    end, installed)
  end,
})


-- :Size <width> [<height>]
--     -    Leaves as it is
--     N    Sets
--    +N    Increases
--    -N    Decreases
--    %N    Percentaje relative to full window size
vim.api.nvim_create_user_command('Size', function(args)
  local function parse(value, max)
    if not value or value == '-' then
      return nil
    end

    local percent = value:match("^%%(%d+)$")
    if percent then
      return math.max(1, math.floor(tonumber(percent) / 100 * max))
    end

    local num = tonumber(value)
    if not num then
      vim.notify('Invalid size: ' .. value, vim.log.levels.ERROR)
      return nil
    end

    return math.max(1, num)
  end

  local win = vim.api.nvim_get_current_win()

  local width  = parse(args.fargs[1], vim.o.columns)
  local height = parse(args.fargs[2], vim.o.lines)

  if width then
    vim.api.nvim_win_set_width(win, width)
  end

  if height then
    vim.api.nvim_win_set_height(win, height)
  end
end, {
  desc = 'Resize window',
  nargs = '+',
})


-- Go to a specific location in file with a command
-- Examples:
--     :Go 100
--     :Go 100 10
--     :Go 100:10
--     :Go 100,10
--     :Go 100a10
vim.api.nvim_create_user_command('Go', function(args)
  local line, col

  -- Accept: "line", "line col", "line:col"
  if #args.fargs == 1 then
    line, col = args.fargs[1]:match("^(%d+)%D?(%d*)$")
    col = tonumber(col) or vim.fn.col('.')
  elseif #args.fargs == 2 then
    line = args.fargs[1]
    col  = args.fargs[2]
  else
    vim.notify('Usage: :Go <line> [<col>]', vim.log.levels.ERROR)
    return
  end

  line = tonumber(line)
  col  = tonumber(col)
  if not line or not col then
    vim.notify('Line and column must be numbers', vim.log.levels.ERROR)
    return
  end

  -- Clamp line to buffer
  local max_line = vim.api.nvim_buf_line_count(0)
  line = math.max(1, math.min(line, max_line))

  -- Push jumplist entry
  vim.cmd("normal! m'")
  vim.api.nvim_win_set_cursor(0, { line, col - 1 })
end, {
  desc = 'Go to location in current file',
  nargs = '+',
})


-------------------------------------------------------------------------------
---- Auto Commands ------------------------------------------------------------
-------------------------------------------------------------------------------

-- Common group for my autocommands, so they can be managed together
local augroup = vim.api.nvim_create_augroup('magno', { clear = true })


-- Highlight on yank. See :h vim.hl.on_yank()
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = augroup,
  callback = function() vim.hl.on_yank() end,
})


-- Create directories on save if they don't exist
-- Taken from: https://github.com/radleylewis/nvim-lite
vim.api.nvim_create_autocmd('BufWrite', {
  desc = 'Create directories on save',
  group = augroup,
  callback = function()
    local current_dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(current_dir) == 0 then
      vim.fn.mkdir(current_dir, 'p')
    end
  end
})


-- Configure options in terminals
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Configure terminal',
  group = augroup,
  callback = function()
    -- No numbers
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

    -- Wrapping (in case I change the original to false)
    vim.opt_local.wrap = true
  end,
})

