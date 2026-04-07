return {
  { -- テキストオブジェクトの拡張(ar/irで[ ]を選択など)
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = {
      custom_textobjects = {
        r = { '%b[]', '^.().*().$' },
      },
    },
  },
  { -- 囲み構造を意味単位として追加・変更・削除操作をできるようにする
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
      vim.keymap.set('n', 's', 'ys', { remap = true })
    end
  },
  { -- 自動で括弧を補完
    'LunarWatcher/auto-pairs',
    init = function()
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
      for _, mode in ipairs({ 'normal', 'visual' }) do
        local m = mode:sub(1, 1)
        map(m, '<C-a>', function() require 'dial.map'.manipulate('increment', mode) end)
        map(m, '<C-x>', function() require 'dial.map'.manipulate('decrement', mode) end)
        map(m, 'g<C-a>', function() require 'dial.map'.manipulate('increment', 'g' .. mode) end)
        map(m, 'g<C-x>', function() require 'dial.map'.manipulate('decrement', 'g' .. mode) end)
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
      local word = function(case) return function() require 'textcase'.current_word(case) end end
      local op = function(case) return function() require 'textcase'.operator(case) end end
      vim.keymap.set('n', 'gak', word('to_dash_case'), { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'ga-', word('to_dash_case'), { desc = 'to-kebab-case' })
      vim.keymap.set('v', 'ga-', 'gad', { remap = true, desc = 'to-kebab-case' })
      vim.keymap.set('n', 'ga_', word('to_snake_case'), { desc = 'to_snake_case' })
      vim.keymap.set('v', 'ga_', 'gas', { remap = true, desc = 'to_snake_case' })
      vim.keymap.set('n', 'gaC', word('to_pascal_case'), { desc = 'ToUpperCamelCase' })
      vim.keymap.set('n', 'gaok', op('to_dash_case'), { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'gao-', op('to_dash_case'), { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'gao_', op('to_snake_case'), { desc = 'to_snake_case' })
      vim.keymap.set('n', 'gaoC', op('to_pascal_case'), { desc = 'ToUpperCamelCase' })
    end
  },
}
