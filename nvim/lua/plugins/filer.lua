return {
  { -- ファイルエクスプローラー
    'stevearc/oil.nvim',
    opts = {
      float = { padding = 4, max_width = 150 },
      view_options = { show_hidden = true },
      keymaps = {
        ['q'] = 'actions.close',
      },
    },
    init = function()
      vim.keymap.set('n', '<leader>s', ':<C-u>Oil --float<CR>')
      require 'easy-setup-autocmd'.setup_autocmd {
        ['FileType'] = {
          pattern = 'oil',
          callback = function()
            vim.keymap.set('n', '<leader><cr>', ':w<CR>', { buffer = true })
          end
        }
      }
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
