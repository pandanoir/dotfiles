local M = {}
local group = vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })
function M.setup_autocmd(autocmds)
  for event_str, opts in pairs(autocmds) do
    opts.group = group
    local events = vim.split(event_str, ',')
    vim.api.nvim_create_autocmd(events, opts)
  end
end

return M
