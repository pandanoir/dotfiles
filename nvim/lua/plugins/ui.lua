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
      builtin_marks = { '.', '^' },
      excluded_buftypes = { 'nofile' },
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
  },
  {
    'kevinhwang91/nvim-hlslens',
    init = function()
      local map = vim.keymap.set
      local kopts = { silent = true }
      map('n', 'n', [[<Cmd>execute('normal! '.v:count1.'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      map('n', 'N', [[<Cmd>execute('normal! '.v:count1.'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      map('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      map('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      map('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      map('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
    config = true,
  },
  {
    'b0o/incline.nvim',
    opts = {
      window = {
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        local helpers = require 'incline.helpers'
        local devicons = require 'nvim-web-devicons'
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if filename == '' then
          filename = '[No Name]'
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        if not ft_icon then
          return {
            { '', guibg = 'none', guifg = '#44406e' },
            { ' ', filename, ' ', gui = modified and 'bold,italic' or 'bold', guibg = '#44406e' },
          }
        end

        return {
          { '', guibg = 'none', guifg = ft_color },
          { ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) },
          { ' ', filename, ' ', gui = modified and 'bold,italic' or 'bold', guibg = '#44406e' },
        }
      end,
    },
    event = 'VeryLazy',
  },
}
