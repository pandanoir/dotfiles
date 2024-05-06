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
    'shellRaining/hlchunk.nvim',
    event = 'UIEnter',
    config = true,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    opts = {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    },
  },
  {
    'folke/tokyonight.nvim',
    init = function()
      vim.cmd [[colorscheme tokyonight]]
    end,
    opts = {
      style = 'night',
    },
  },
  {
    'j-hui/fidget.nvim',
    config = true,
  }
}
