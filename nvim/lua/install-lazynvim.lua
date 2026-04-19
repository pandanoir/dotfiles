vim.pack.add({
  { src = 'https://github.com/folke/lazy.nvim.git', version = 'stable' },
}, { load = true })

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { desc = 'open lazy.nvim window' })
