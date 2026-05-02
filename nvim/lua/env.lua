local M = {}

M.from_claude = vim.iter(vim.fn.argv()):any(function(a)
  return a:match('claude%-prompt')
end)

M.is_ci = vim.env.CI == 'true'

-- Neovim 0.12 で補完が強化されたためネイティブ補完を使う
M.has_native_completion = vim.fn.has('nvim-0.12') == 1

return M