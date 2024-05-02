return {
  {
    'bronson/vim-trailing-whitespace',
    event = 'BufRead',
  },
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
    event = 'BufRead',
    opts = {
      builtin_marks = { ".", "^" },
      excluded_buftypes = { "nofile" },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = true,
  },
  {
    'romgrk/barbar.nvim',
    event = 'BufRead',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
  },
  {
    'kevinhwang91/nvim-ufo',
    event = 'BufRead',
    dependencies = 'kevinhwang91/promise-async',
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end
    },
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
  }
