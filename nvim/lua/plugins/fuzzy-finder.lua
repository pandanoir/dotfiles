return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
  cmd = { 'Telescope' },
  keys = {
    { '<leader>;', '<cmd>Telescope resume<cr>' },
  },
  init = function()
    require('which-key').register({
      f = {
        name = 'fuzzy finder',
        f = { '<cmd>Telescope find_files<cr>', 'Find File' },
        g = { '<cmd>Telescope live_grep<cr>', 'Grep' },
        b = { '<cmd>Telescope buffers<cr>', 'Buffers' },
        r = { '<cmd>Telescope oldfiles<cr>', 'Old files' },
        G = {
          function() require('telescope.builtin').live_grep { default_text = vim.fn.expand('<cword>') } end,
          'Grep with current word'
        },
      },
    }, { prefix = '<leader>' })
  end,
  opts = {
    defaults = {
      mappings = {
        n = { q = 'close' },
      },
    },
  },
}
