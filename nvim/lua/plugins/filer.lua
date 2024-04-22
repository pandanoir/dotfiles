return {
  'stevearc/oil.nvim',
  opts = { float = { padding = 4, max_width = 150 } },
  init = function()
    vim.keymap.set('n', '<leader>s', ':<C-u>Oil --float<CR>')
    vim.cmd [[autocmd FileType oil nnoremap <buffer> <leader><cr> :w<CR>]]
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
