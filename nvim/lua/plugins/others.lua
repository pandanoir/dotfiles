return {
  {
    'vim-scripts/surround.vim',
    event = 'VimEnter',
    init = function()
      vim.keymap.set('n', 's', 'ys', { remap = true })
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VimEnter',
    opts = {
      enable_autocmd = false,
    },
    init = function()
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring'
            and require 'ts_context_commentstring.internal'.calculate_commentstring()
            or get_option(filetype, option)
      end
    end
  },
  {
    'LunarWatcher/auto-pairs',
    init = function()
      vim.api.nvim_set_var('AutoPairsCompleteOnlyOnSpace', 1)
      vim.g.AutoPairsCompleteOnlyOnSpace = 1
      vim.g.AutoPairsShortcutJump = ''
      vim.g.AutoPairsShortcutToggle = ''
      vim.g.AutoPairsShortcutToggleMultilineClose = ''
    end
  },
  {
    'kana/vim-textobj-user',
    event = 'VimEnter',
    config = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.call('textobj#user#plugin', 'braces', {
        angle = {
          pattern = { "\\[", "\\]" },
          ['select-a'] = 'ar',
          ['select-i'] = 'ir',
        },
      })
    end
  },
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
  {
    'Wansmer/treesj',
    keys = {
      { '<leader>j', '<cmd>TSJToggle<cr>', desc = 'join with treesj' },
      { '<leader>J', '<cmd>TSJJoin<cr>',   desc = 'join with treesj' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { use_default_keymaps = false },
  },
  'ojroques/nvim-bufdel',
  {
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
  'Shougo/context_filetype.vim',
  { 'bronson/vim-visual-star-search', event = 'VeryLazy' },
  {
    'johmsalas/text-case.nvim',
    config = true,
    init = function()
      local op = require 'textcase'.operator
      local word = require 'textcase'.current_word
      vim.keymap.set('n', 'gak', function() word('to_dash_case') end, { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'gaC', function() word('to_pascal_case') end, { desc = 'ToUpperCamelCase' })
      vim.keymap.set('n', 'gaok', function() op('to_dash_case') end, { desc = 'to-kebab-case' })
      vim.keymap.set('n', 'gaoC', function() op('to_pascal_case') end, { desc = 'ToUpperCamelCase' })
    end
  }
}
