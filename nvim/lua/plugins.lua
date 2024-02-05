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
  'Shougo/context_filetype.vim',
  {
    'rbtnn/vim-ambiwidth',
    config = function()
      vim.g.ambiwidth_cica_enabled = false
    end
  },
  'anuvyklack/keymap-amend.nvim',
  'nvim-tree/nvim-web-devicons',
  { 'anuvyklack/pretty-fold.nvim', config = true },
  {
    'anuvyklack/fold-preview.nvim',
    dependencies = { 'anuvyklack/keymap-amend.nvim' },
    config = true,
  },
  {
    'folke/tokyonight.nvim',
    config = function()
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
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'Telescope' },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
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
  'nvim-lua/plenary.nvim',
  {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    init = function()
      vim.keymap.set('n', '<leader>s', ':<C-u>NvimTreeToggle<CR>')
    end,
    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true

      require 'nvim-tree'.setup {
        update_focused_file = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      }
    end
  },
  {
    'sbdchd/neoformat',
    cmd = 'Neoformat',
    ft = { 'javascript', 'javascript.jsx', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue' },
    config = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_enabled_javascript = { 'prettier', 'jsbeautify' }
      vim.cmd 'command! -range=% Fmt :mkview | :<line1>,<line2>Neoformat | :loadview'
      vim.cmd [[augroup fmt autocmd! autocmd BufWritePre * Fmt augroup END]]
    end
  },
  {
    'LunarWatcher/auto-pairs',
    config = function()
      vim.api.nvim_set_var('AutoPairsCompleteOnlyOnSpace', 1)
      vim.g.AutoPairsCompleteOnlyOnSpace = 1
      vim.g.AutoPairsShortcutJump = ''
      vim.g.AutoPairsShortcutToggle = ''
      vim.g.AutoPairsShortcutToggleMultilineClose = ''
    end
  },

  { 'kana/vim-textobj-user',       event = 'VimEnter' },
  {
    'vim-scripts/surround.vim',
    event = 'VimEnter',
    init = function() vim.keymap.set('n', 's', 'ys', { remap = true }) end
  },

  {
    'tpope/vim-repeat',
    event = 'VimEnter',
    config = function()
      vim.cmd [[
              function! Execute_repeatable_macro(name)
              const name = '@' .. a:name

              execute 'normal!' name
              silent! call repeat#set('\<Plug>macro_' .. a:name)
              endfunction

              for x in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
                execute 'nnoremap' '<silent>' ('<Plug>macro_' .. x) ("'\<C-u>call Execute_repeatable_macro('" .. x .. "')\<CR>")
                execute 'nmap' ('@' .. x) ('<Plug>macro_' .. x)
                endfor
                ]]
    end
  },

  { 'justinmk/vim-sneak', event = 'VimEnter' },
  {
    'echasnovski/mini.comment',
    opts = {
      hooks = {
        pre = function()
          vim.cmd('noa setfiletype ' .. vim.fn['context_filetype#get_filetypes']()[1])
        end,
        post = function()
          vim.cmd 'filetype detect'
        end
      }
    },
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
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
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
    end,
  },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  {
    'neovim/nvim-lspconfig',
    config = function() require 'plugins.lspconfig' end,
    dependencies = { 'glepnir/lspsaga.nvim', 'hrsh7th/nvim-cmp', 'williamboman/mason-lspconfig.nvim' },
  },
  { 'folke/neodev.nvim',  config = true },

  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter',
    build = function()
      local ts_update = require 'nvim-treesitter.install'.update { with_sync = true }
      ts_update()
    end,
    config = function()
      require 'nvim-treesitter.configs'.setup {
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
      }
      vim.defer_fn(function()
        vim.cmd [[TSEnable highlight]]
      end, 50)
    end
  }
}
