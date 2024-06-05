return {
  -- handy utils
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
    config = true,
  },
  {
    'echasnovski/mini.comment',
    event = 'VimEnter',
    opts = {
      options = {
        custom_commentstring = function()
          return require 'ts_context_commentstring'.calculate_commentstring() or
              vim.bo.commentstring
        end,
      }
    }
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
          ["select-a"] = 'ar',
          ["select-i"] = 'ir',
        },
      })
    end
  },
  {
    'tpope/vim-repeat',
    event = 'VimEnter',
  },
  {
    'justinmk/vim-sneak',
    event = 'VimEnter',
    init = function()
      vim.keymap.set('n', 'f', '<Plug>Sneak_f', { remap = true })
      vim.keymap.set('n', 'F', '<Plug>Sneak_F', { remap = true })
      vim.keymap.set('n', 't', '<Plug>Sneak_t', { remap = true })
      vim.keymap.set('n', 'T', '<Plug>Sneak_T', { remap = true })
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      local timeoutlen = 400
      vim.o.timeout = true
      vim.o.timeoutlen = timeoutlen
      local group = vim.api.nvim_create_augroup('which-key', {})
      vim.api.nvim_create_autocmd('InsertEnter', {
        group = group,
        callback = function() vim.o.timeoutlen = 200 end,
      })
      vim.api.nvim_create_autocmd('InsertLeave', {
        group = group,
        callback = function() vim.o.timeoutlen = timeoutlen end,
      })
    end,
    opts = {
      triggers_blacklist = {
        i = { "f" },
      }
    },
  },
  {
    'Wansmer/treesj',
    keys = {
      { '<leader>m', '<cmd>TSJToggle<cr>' },
      { '<leader>j', '<cmd>TSJJoin<cr>' },
      { '<leader>J', '<cmd>TSJSplit<cr>' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { use_default_keymaps = false },
  },

  -- others
  'Shougo/context_filetype.vim',
  { 'bronson/vim-visual-star-search', event = 'VeryLazy' },
}
