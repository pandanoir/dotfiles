local M = {}
function M.setup_autocmd(autocmds)
  local group = vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

  for event_str, opts in pairs(autocmds) do
    opts.group = group
    local events = vim.split(event_str, ',')
    vim.api.nvim_create_autocmd(events, opts)
  end
end

return M
