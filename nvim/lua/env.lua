local M = {}

M.from_claude = vim.iter(vim.fn.argv()):any(function(a)
  return a:match('claude%-prompt')
end)

return M