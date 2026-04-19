---- Gitsigns -----------------------------------------------------------------
-- Adds signs to the sign-column to indicate added, changed and deleted text
--
-- HUNKS (block of changes)
--     :Gitsigns stage_hunk          Stage/Unstage
--     :Gitsigns reset_hunk          Revert changes
--     :Gitsigns preview_hunk_inline See the actual changes
--     :Gitsigns preview_hunk        Same as before, but in a pop-up window
--     :Gitsigns nav_hunk prev/next  Navigation between changes
--     :Gitsigns setqflist           Open quickfix window with hunks
--     :Gitsigns setloclist          Open location list with hunks
--
-- GIT BLAME
--     :Gitsigns blame               Blame of current buffer in a new window
--     :Gitsigns blame_line          Blame current line in a pop-up
--     :Gitsigns toggle_current_line_blame Toggle virtual text blame of the current line
--
-- GIT DIFF
--     :Gitsigns change_base {rev}   Change the base commit for comparison
--     :Gitsigns diffthis {rev}      Show diff of the current buffer
--     :Gitsigns toggle_word_diff    Intraline word-diff
local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  vim.notify('gitsigns is not available', vim.log.levels.WARN)
  return
end

gitsigns.setup({
  on_attach = function(bfn)
    vim.keymap.set('n', '[h', function() gitsigns.nav_hunk('next') end, {desc = 'Next hunk', silent = true, buffer = bfn})
    vim.keymap.set('n', ']h', function() gitsigns.nav_hunk('prev') end, {desc = 'Previous hunk', silent = true, buffer = bfn})
  end
})

