return {
  { -- .コマンドでプラグインの操作を繰り返せるようにする
    'tpope/vim-repeat',
    event = 'VimEnter',
  },
  { -- テキストオブジェクトの拡張基盤
    'kana/vim-textobj-user',
    event = 'VimEnter',
    config = function()
      vim.call('textobj#user#plugin', 'braces', {
        angle = {
          pattern = { "\\[", "\\]" },
          ['select-a'] = 'ar',
          ['select-i'] = 'ir',
        },
      })
    end
  },
  { -- 囲み構造を意味単位として追加・変更・削除操作をできるようにする
    'vim-scripts/surround.vim',
    event = 'VimEnter',
    init = function()
      vim.keymap.set('n', 's', 'ys', { remap = true })
    end
  },
  { -- 自動で括弧を補完
    'LunarWatcher/auto-pairs',
    init = function()
      vim.api.nvim_set_var('AutoPairsCompleteOnlyOnSpace', 1)
      vim.g.AutoPairsCompleteOnlyOnSpace = 1
      vim.g.AutoPairsShortcutJump = ''
      vim.g.AutoPairsShortcutToggle = ''
      vim.g.AutoPairsShortcutToggleMultilineClose = ''
    end
  },
  { -- コードブロックの結合と分割
    'Wansmer/treesj',
    keys = {
      { '<leader>j', '<cmd>TSJToggle<cr>', desc = 'join or split using treesj' },
      { '<leader>J', '<cmd>TSJJoin<cr>',   desc = 'join using treesj' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { use_default_keymaps = false },
  },
  { -- インクリメント/デクリメントで日付やboolean値を操作
    'monaqa/dial.nvim',
    init = function()
      local map = vim.keymap.set
      local manipulate = require 'dial.map'.manipulate
      for _, mode in ipairs({ 'normal', 'visual' }) do
        local m = mode:sub(1, 1)
        map(m, '<C-a>', function() manipulate('increment', mode) end)
        map(m, '<C-x>', function() manipulate('decrement', mode) end)
        map(m, 'g<C-a>', function() manipulate('increment', 'g' .. mode) end)
        map(m, 'g<C-x>', function() manipulate('decrement', 'g' .. mode) end)
      end
    end,
    config = function()
      local augend = require 'dial.augend'
      require 'dial.config'.augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
        },
      }
    end
  },
  { -- 文字列のケース変換(snake_case、kebab-caseなど)
    'johmsalas/text-case.nvim',
    config = true,
    init = function()
      local op = require 'textcase'.operator
      local word = require 'textcase'.current_word
      vim.keymap.set('n', 'gak', function() word('to_dash_case') end, { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'ga-', function() word('to_dash_case') end, { desc = 'to-kebab-case' })
      vim.keymap.set('v', 'ga-', 'gad', { remap = true, desc = 'to-kebab-case' })
      vim.keymap.set('n', 'ga_', function() word('to_snake_case') end, { desc = 'to_snake_case' })
      vim.keymap.set('v', 'ga_', 'gas', { remap = true, desc = 'to_snake_case' })
      vim.keymap.set('n', 'gaC', function() word('to_pascal_case') end, { desc = 'ToUpperCamelCase' })
      vim.keymap.set('n', 'gaok', function() op('to_dash_case') end, { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'gao-', function() op('to_dash_case') end, { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'gao_', function() op('to_snake_case') end, { desc = 'to_snake_case' })
      vim.keymap.set('n', 'gaoC', function() op('to_pascal_case') end, { desc = 'ToUpperCamelCase' })
    end
  },
}
