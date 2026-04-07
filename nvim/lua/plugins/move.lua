return {
  { -- f/t/F/Tの検索を強化（migemo対応）
    'rhysd/clever-f.vim',
    keys = {
      { 'f', mode = { 'n', 'x', 'o' } },
      { 'F', mode = { 'n', 'x', 'o' } },
      { 't', mode = { 'n', 'x', 'o' } },
      { 'T', mode = { 'n', 'x', 'o' } },
      { ';', '<Plug>(clever-f-repeat-forward)', remap = true },
      { ',', '<Plug>(clever-f-repeat-back)',    remap = true },
    },
    init = function()
      vim.g.clever_f_use_migemo = 1
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
      vim.keymap.set('i', '<c-l>', function() require('in-and-out').in_and_out() end)
    end,
  },
}
