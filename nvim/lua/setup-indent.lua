vim.g.markdown_recommended_style = 0 -- デフォルトだとshiftwidth=4などが設定されるので無効にする

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.cmd [[filetype plugin on]]

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  pattern = '*',
  callback = function()
    -- 自動でコメントが入るのを防ぐ
    vim.opt_local.formatoptions:remove('ro')
  end
})
