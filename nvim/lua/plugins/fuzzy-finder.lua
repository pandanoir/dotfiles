return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
  cmd = { 'Telescope' },
  keys = {
    { '<leader>;', '<cmd>Telescope resume<cr>' },
  },
  init = function()
    require 'which-key'.add {
      { '<leader>f',  group = 'fuzzy finder', },
      {
        '<leader>fG',
        function() require('telescope.builtin').live_grep { default_text = vim.fn.expand('<cword>') } end,
        desc = 'Grep with current word'
      },
      { '<leader>fb', '<cmd>Telescope buffers<cr>',    desc = 'Buffers' },
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find File' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>',  desc = 'Grep' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>',   desc = 'Old files' },
    }
  end,
  opts = {
    defaults = {
      mappings = {
        n = { q = 'close' },
      },
    },
  },
}
