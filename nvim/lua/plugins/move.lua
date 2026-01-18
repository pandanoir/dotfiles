return {
  { -- f/t/F/Tの検索を強化（migemo対応）
    'rhysd/clever-f.vim',
    event = 'VimEnter',
    init = function()
      vim.g.clever_f_use_migemo = 1
      vim.keymap.set('n', ';', '<Plug>(clever-f-repeat-forward)', { remap = true })
      vim.keymap.set('n', ',', '<Plug>(clever-f-repeat-back)', { remap = true })
    end,
  },
  { -- ビジュアルモードで*検索を改善
    'bronson/vim-visual-star-search',
    event = 'VeryLazy',
  },
  { -- 括弧の内外を移動
    'ysmb-wtsg/in-and-out.nvim',
    keys = {
      {
        '<C-CR>',
        function()
          require 'in-and-out'.in_and_out()
        end,
        mode = 'i'
      },
    },
    init = function()
      vim.keymap.set(
        'i',
        '<c-l>',
        require('in-and-out').in_and_out
      )
    end,
  },
}
