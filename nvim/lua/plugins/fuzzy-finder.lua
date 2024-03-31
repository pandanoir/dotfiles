return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'Telescope' },
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<cr>' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
    { '<leader>fb', '<cmd>Telescope buffers<cr>' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>' },
    { '<leader>;',  '<cmd>Telescope resume<cr>' },
    {
      '<leader>fG',
      function()
        require('telescope.builtin').live_grep { default_text = vim.fn.expand('<cword>') }
      end
    }
  },
  opts = {
    defaults = {
      mappings = {
        n = { q = 'close' },
      },
    },
  },
}
