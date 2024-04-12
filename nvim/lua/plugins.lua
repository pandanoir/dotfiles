local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set('n', '<leader>l', ':Lazy<CR>')
require 'lazy'.setup {
  -- ui
  {
    'rbtnn/vim-ambiwidth',
    init = function()
      vim.g.ambiwidth_cica_enabled = false
    end
  },
  {
    'anuvyklack/pretty-fold.nvim',
    config = true,
  },
  {
    'anuvyklack/fold-preview.nvim',
    dependencies = { 'anuvyklack/keymap-amend.nvim' },
    config = true,
  },
  {
    'chentoast/marks.nvim',
    opts = { builtin_marks = { ".", "^" } },
  },
  {
    'nathanaelkane/vim-indent-guides',
    event = 'VimEnter',
    init = function()
      vim.g.indent_guides_enable_on_vim_startup = 1
      vim.g.indent_guides_auto_colors = 0
      vim.g.indent_guides_exclude_filetypes = { 'alpha' }
      vim.cmd [[autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#2e3248 ctermbg=0]]
    end
  },
  require 'plugins.treesitter',
  require 'plugins.colorscheme',
  require 'plugins.lualine',

  -- lsp
  {
    'glepnir/lspsaga.nvim',
    event = 'BufRead',
    opts = {
      finder = {
        keys = {
          toggle_or_open = '<CR>',
          quit = { 'q', '<ESC>' },
        },
      },
    },
  },
  require 'plugins.completion',
  {
    'folke/neodev.nvim',
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    init = function()
      require 'plugins.lspconfig'
    end,
    dependencies = {
      'folke/neodev.nvim',
      'glepnir/lspsaga.nvim',
      'hrsh7th/nvim-cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    },
  },

  require 'plugins.fuzzy-finder',
  require 'plugins.filer',

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
          return require 'ts_context_commentstring'.calculate_commentstring() or vim.bo.commentstring
        end,
      }
    }
  },
  require 'plugins.formatter',
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

  -- others
  'Shougo/context_filetype.vim',
  { 'bronson/vim-visual-star-search', event = 'VeryLazy' },
  require 'plugins.alpha-nvim',
}
