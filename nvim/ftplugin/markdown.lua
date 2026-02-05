-- claude promptでフォーマッターを走らせたくない
if require('env').from_claude then
  -- markdown & formatter & treesitter 全部止める
  vim.bo.filetype = ''
  vim.b.disable_autoformat = true
  vim.bo.formatexpr = ''
  vim.bo.formatprg = ''
end