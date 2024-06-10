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
  {
    'stevearc/conform.nvim',
    init = function()
      vim.keymap.set(
        'n',
        '<leader>F',
        function() require 'conform'.format { lsp_fallback = true } end,
        { silent = true }
      )
    end,
    opts = function()
      return {
        formatters = {
          -- config working directory に prettierrc がある場合に利用可能とみなす
          -- cf. https://github.com/stevearc/conform.nvim/issues/407#issuecomment-2120988992
          prettier = {
            require_cwd = true,
            cwd = require('conform.util').root_file({
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.js',
              '.prettierrc.cjs',
              '.prettierrc.mjs',
              'prettier.config.js',
              'prettier.config.cjs',
              'prettier.config.mjs',
            }),
          },
          biome = { require_cwd = true },
        },
        formatters_by_ft = {
          javascript = { { 'prettier', 'biome' } },
          typescript = { { 'prettier', 'biome' } },
          typescriptreact = { { 'prettier', 'biome' } },
          vue = { { 'prettier', 'biome' } },
          lua = { 'stylua' },
        },
        format_on_save = {
          lsp_fallback = true,
        },
      }
    end,
  },
  'ojroques/nvim-bufdel',

  -- others
  'Shougo/context_filetype.vim',
  { 'bronson/vim-visual-star-search', event = 'VeryLazy' },
}
