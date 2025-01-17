return {
  {
    'tpope/vim-repeat',
    event = 'VimEnter',
  },
  {
    'rhysd/clever-f.vim',
    event = 'VimEnter',
    init = function()
      vim.g.clever_f_use_migemo = 1
      vim.keymap.set('n', ';', '<Plug>(clever-f-repeat-forward)', { remap = true })
      vim.keymap.set('n', ',', '<Plug>(clever-f-repeat-back)', { remap = true })
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      defer = function(ctx)
        return vim.list_contains({ '<C-V>', 'V', 'v' }, ctx.mode)
      end,
      sort = { 'alphanum' },
    },
    config = function(_, opts)
      require 'which-key'.setup(opts)
      require 'which-key'.add {
        { '<leader>t', group = 'toggle', },
        {
          'gf',
          function()
            local cfile = vim.fn.expand('<cfile>')
            print(cfile)
            if cfile:match('^https?://') then
              vim.fn.system { 'open', '-a', 'google chrome', cfile }
            else
              vim.cmd 'normal! gF'
            end
          end,
          desc = 'Go to file under cursor',
        }
      }
    end,
    init = function()
      local timeoutlen = 400
      vim.o.timeout = true
      vim.o.timeoutlen = timeoutlen

      require 'easy-setup-autocmd'.setup_autocmd {
        ['InsertEnter'] = {
          callback = function() vim.o.timeoutlen = 200 end,
        },
        ['InsertLeave'] = {
          callback = function() vim.o.timeoutlen = timeoutlen end,
        }
      }
    end,
  },
  'ojroques/nvim-bufdel',
  'Shougo/context_filetype.vim',
  { 'bronson/vim-visual-star-search', event = 'VeryLazy' },
  {
    'ysmb-wtsg/in-and-out.nvim',
    commit = '2f3bf83654790e458cf387fa6f37f9b9d9e4f7fa',
    init = function()
      vim.keymap.set(
        'i',
        '<c-l>',
        require('in-and-out').in_and_out
      )
    end,
  },
}
