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

require 'lazy'.setup {
  -- ui
  {
    'rbtnn/vim-ambiwidth',
    init = function()
      vim.g.ambiwidth_cica_enabled = false
    end
  },
  'nvim-tree/nvim-web-devicons',
  {
    'anuvyklack/pretty-fold.nvim',
    config = true,
  },
  'anuvyklack/keymap-amend.nvim',
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
      vim.cmd [[autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=none ctermbg=none]]
      vim.cmd [[autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#2e3248 ctermbg=0]]
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter',
    build = function()
      local ts_update = require 'nvim-treesitter.install'.update { with_sync = true }
      ts_update()
    end,
    init = function()
      vim.defer_fn(function()
        vim.cmd [[TSEnable highlight]]
      end, 50)
    end,
    opts = {
      ensure_installed = {
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'css',
        'html',
        'json',
        'lua',
        'markdown_inline',
        'markdown',
        'scss',
        'toml',
        'vim'
      },
      additional_vim_regex_highlighting = false,
    },
  },
  {
    'folke/tokyonight.nvim',
    init = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_transparent_background = 1
      vim.cmd [[colorscheme tokyonight]]
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    opts = {
      options = {
        theme = 'onedark',
      },
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

  -- lsp
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
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
  {
    'hrsh7th/nvim-cmp',
    opts = function()
      local cmp = require 'cmp'
      return {
        enabled = true,
        mapping = cmp.mapping.preset.insert {
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
        },
      }
    end
  },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  {
    'neovim/nvim-lspconfig',
    init = function()
      require 'plugins.lspconfig'
    end,
    dependencies = {
      'folke/neodev.nvim',
      'glepnir/lspsaga.nvim',
      'hrsh7th/nvim-cmp',
      'williamboman/mason-lspconfig.nvim'
    },
  },
  {
    'folke/neodev.nvim',
    config = true,
  },

  -- fuzzy finder
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'Telescope' },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>' },
      { '<leader>;',  '<cmd>Telescope resume<cr>' },
      {
        '<leader>fG',
        function()
          require('telescope.builtin').live_grep { default_text = vim.fn.expand('<cword>') }
        end
      }
    },
    opts = {
      defaults = {
        mappings = {
          n = { q = 'close' },
        },
      },
    },
  },

  -- filer
  {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    keys = { { '<leader>s', ':<C-u>NvimTreeToggle<CR>' } },
    init = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true
    end,
    opts = {
      update_focused_file = {
        enable = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
  },

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
  {
    'sbdchd/neoformat',
    cmd = 'Neoformat',
    ft = { 'javascript', 'javascript.jsx', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue' },
    init = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_enabled_javascript = { 'prettier', 'jsbeautify' }
      vim.cmd 'command! -range=% Fmt :mkview | :<line1>,<line2>Neoformat | :loadview'
      vim.cmd [[augroup fmt autocmd! autocmd BufWritePre * Fmt augroup END]]
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
  },

  -- others
  'Shougo/context_filetype.vim',
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    keys = { { '<leader>,', ':<C-u>Alpha<CR>' } },
    opts = function()
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.buttons.val = {
        dashboard.button('t', '  nvim-tree', ':NvimTreeToggle<cr>'),
        dashboard.button('f', ' ' .. ' Find file', '<cmd> Telescope find_files <cr>'),
        dashboard.button('n', ' ' .. ' New file', '<cmd> ene <BAR> startinsert <cr>'),
        dashboard.button('r', ' ' .. ' Recent files', '<cmd> Telescope oldfiles <cr>'),
        dashboard.button('g', ' ' .. ' Find text', '<cmd> Telescope live_grep <cr>'),
        dashboard.button('l', '󰒲 ' .. ' Lazy', '<cmd> Lazy <cr>'),
        dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <cr>'),
      }

      local function footer()
        local total_plugins = #vim.tbl_keys(require 'lazy'.plugins())
        local datetime = os.date(' %Y-%m-%d   %H:%M:%S')
        local version = vim.version()
        local version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
        return datetime .. '  ⚡' .. total_plugins .. ' plugins' .. version_info
      end
      dashboard.section.footer.val = footer()

      return dashboard.opts
    end
  },
}
