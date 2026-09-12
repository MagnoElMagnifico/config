-- Custom plugin to convert variable names:
--
-- - leader + - + motion  ==>  kebab-case
-- - leader + _ + motion  ==>  snake_case
-- - leader + s + motion  ==>  SCREAMING_SNAKE_CASE
-- - leader + a + motion  ==>  Train_Case
-- - leader + p + motion  ==>  PascalCase
-- - leader + c + motion  ==>  camelCase

local plug_leader = 's'
local cases = {
  -- mini.surround uses: a, d, r, f, h
  ['-'] = 'kebab',
  ['_'] = 'snake',
  ['s'] = 'screaming_snake',
  ['t'] = 'train',
  ['p'] = 'pascal',
  ['c'] = 'camel',
}

-- Split text into lowercase word parts
local function split_words(s)
  -- separators to spaces
  s = s:gsub('[_-]', ' ')
  -- insert space before each new capital
  s = s:gsub('(%l)(%u)', '%1 %2')
  -- sequences with multiple capitals
  s = s:gsub('(%u)(%u%l)', '%1 %2')
  local words = {}
  for w in s:gmatch('%S+') do
    table.insert(words, w:lower())
  end
  return words
end

local converters = {
  kebab = function(words) return table.concat(words, '-') end,
  snake = function(words) return table.concat(words, '_') end,
  screaming_snake = function(words)
    local up = {}
    for i, w in ipairs(words) do up[i] = w:upper() end
    return table.concat(up, '_')
  end,
  train = function(words)
    local cap = {}
    for i, w in ipairs(words) do cap[i] = w:sub(1,1):upper() .. w:sub(2) end
    return table.concat(cap, '_')
  end,
  pascal = function(words)
    local out = {}
    for i, w in ipairs(words) do out[i] = w:sub(1,1):upper() .. w:sub(2) end
    return table.concat(out)
  end,
  camel = function(words)
    local out = {}
    for i, w in ipairs(words) do
      out[i] = i == 1 and w or (w:sub(1,1):upper() .. w:sub(2))
    end
    return table.concat(out)
  end,
}

local pending_case = nil
local function operatorfunc(kind)
  local s = vim.fn.getpos("'[")
  local e = vim.fn.getpos("']")
  local line = vim.fn.getline(s[2])
  local before, target, after
  if kind == 'line' then
    target = line
    before, after = '', ''
  else
    before = line:sub(1, s[3] - 1)
    target = line:sub(s[3], e[3])
    after  = line:sub(e[3] + 1)
  end
  local converted = converters[pending_case](split_words(target))
  vim.fn.setline(s[2], before .. converted .. after)
end
_G.CaseConvOperatorFunc = operatorfunc

local function convert(case)
  pending_case = case
  vim.go.operatorfunc = 'v:lua.CaseConvOperatorFunc'
  return 'g@'
end

for key, case in pairs(cases) do
  vim.keymap.set({ 'n', 'x' }, plug_leader .. key, function()
    return convert(case)
  end, { expr = true, desc = 'Convert to ' .. case })
end





--[[

-- TODO: cursor movement

local function word_chunk_bounds(line, col)
  local class = '[%w_%-]'
  local s, e = col, col
  while s > 1 and line:sub(s - 1, s - 1):match(class) do s = s - 1 end
  while e < #line and line:sub(e + 1, e + 1):match(class) do e = e + 1 end
  return s, e
end

-- returns {s, e} pairs (1-based, relative to `chunk`) for each subword
local function subword_segments(chunk)
  local segments, i, n = {}, 1, #chunk
  while i <= n do
    local c = chunk:sub(i, i)
    if c == '_' or c == '-' then
      i = i + 1
    else
      local j = i + 1
      while j <= n do
        local cj, prev = chunk:sub(j, j), chunk:sub(j - 1, j - 1)
        if cj == '_' or cj == '-' then break end
        if prev:match('%l') and cj:match('%u') then break end          -- fooBar -> foo|Bar
        if prev:match('%u') and cj:match('%u') and chunk:sub(j+1,j+1):match('%l') then break end -- XMLParser -> XML|Parser
        j = j + 1
      end
      table.insert(segments, { i, j - 1 })
      i = j
    end
  end
  return segments
end

local function select_subword(around)
  local line = vim.api.nvim_get_current_line()
  local lnum = vim.fn.line('.')
  local col = vim.fn.col('.')
  local cs, ce = word_chunk_bounds(line, col)
  local chunk = line:sub(cs, ce)
  local cursor_rel = col - cs + 1

  for _, seg in ipairs(subword_segments(chunk)) do
    if cursor_rel >= seg[1] and cursor_rel <= seg[2] then
      local start_col, end_col = cs + seg[1] - 1, cs + seg[2] - 1
      if around and line:sub(cs + seg[2], cs + seg[2]):match('[_%-]') then
        end_col = end_col + 1  -- include trailing separator for `av`
      end
      vim.fn.setpos('.', { 0, lnum, start_col, 0 })
      vim.cmd('normal! v')
      vim.fn.setpos('.', { 0, lnum, end_col, 0 })
      return
    end
  end
end

vim.keymap.set({ 'o', 'x' }, 'iv', function() select_subword(false) end, { desc = 'inner subword' })
vim.keymap.set({ 'o', 'x' }, 'av', function() select_subword(true) end, { desc = 'around subword' })
--]]
