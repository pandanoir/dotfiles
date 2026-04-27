-- LSP進捗をfloating windowで表示する。
-- LspProgressイベントを監視し、スピナー+パーセンテージ+サーバー名を1行で表示。
local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local active = {} -- key: "client_id:token"
local spin_idx, buf, win, timer = 0

local function close()
  if timer then timer:stop(); timer:close(); timer = nil end
  if win and vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  if buf and vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  win, buf = nil, nil
end

local function render()
  spin_idx = (spin_idx + 1) % #spinner
  local lines, max_w = {}, 0
  for _, v in pairs(active) do
    local s = v.done and '✔' or v.percentage and string.format('%s %d%%', spinner[spin_idx + 1], v.percentage) or spinner[spin_idx + 1]
    local line = s .. ' ' .. v.name
    lines[#lines + 1] = line
    max_w = math.max(max_w, vim.fn.strdisplaywidth(line))
  end
  if #lines == 0 then return close() end

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local cfg = {
    relative = 'editor', anchor = 'SE', style = 'minimal', border = 'rounded',
    row = vim.o.lines - 2, col = vim.o.columns,
    width = max_w + 2, height = #lines,
    focusable = false, noautocmd = true,
  }
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_config(win, cfg)
  else
    win = vim.api.nvim_open_win(buf, false, cfg)
    vim.wo[win].winhighlight = 'Normal:NormalFloat,FloatBorder:DiagnosticInfo'
    vim.wo[win].winblend = 10
  end
end

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    local key = ev.data.client_id .. ':' .. ev.data.params.token
    local val = ev.data.params.value

    if val.kind == 'end' then
      active[key] = { name = client.name, done = true }
      vim.defer_fn(function()
        if active[key] and active[key].done then
          active[key] = nil
          if not next(active) then close() end
        end
      end, 1500)
    else
      active[key] = { name = client.name, percentage = val.percentage }
      if not timer then
        timer = vim.uv.new_timer()
        timer:start(0, 100, vim.schedule_wrap(render))
      end
    end
  end,
})
