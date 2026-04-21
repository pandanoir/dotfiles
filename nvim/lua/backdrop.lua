local M = {}

--- floatウィンドウの背後にbackdropを表示する
---@param target_win integer 対象のfloatウィンドウID
---@param zindex? integer 対象ウィンドウのzindex (default: 50)
---@param blend? integer winblend値 (default: 60)
function M.show(target_win, zindex, blend)
  zindex = zindex or 50
  blend = blend or 60

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    style = 'minimal',
    zindex = zindex - 1,
  })

  vim.api.nvim_set_hl(0, 'Backdrop', { bg = '#000000', default = true })
  vim.wo[win].winhighlight = 'Normal:Backdrop'
  vim.wo[win].winblend = blend
  vim.bo[buf].buftype = 'nofile'

  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(target_win),
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    end,
  })
end

return M
