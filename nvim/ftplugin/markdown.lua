-- claude promptでフォーマッターを走らせたくない
if require('env').from_claude then
  vim.b.disable_autoformat = true
  vim.bo.formatexpr = ''
  vim.bo.formatprg = ''
  vim.treesitter.stop(0)
end