return {
  { -- .コマンドでプラグインの操作を繰り返せるようにする
    'tpope/vim-repeat',
    event = 'VimEnter',
  },
  { -- キーバインドの候補を表示
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
        { '<leader><tab>', group = 'toggle', },
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
  { -- バッファ削除を改善
    'ojroques/nvim-bufdel',
  },
  { -- コンテキストに応じたファイルタイプ判定
    'Shougo/context_filetype.vim',
  },
}
