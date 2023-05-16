local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]]

return require 'packer'.startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'rbtnn/vim-ambiwidth',
    config = function()
      vim.g.ambiwidth_cica_enabled = false
    end
  }
  use 'anuvyklack/keymap-amend.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use { 'anuvyklack/pretty-fold.nvim', config = function() require 'pretty-fold'.setup() end }
  use {
    'anuvyklack/fold-preview.nvim',
    requires = { 'anuvyklack/keymap-amend.nvim' },
    config = function() require 'fold-preview'.setup() end,
  }
  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_transparent_background = 1
      vim.cmd [[colorscheme tokyonight]]
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require 'lualine'.setup {
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
      }
    end
  }
  use {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    setup = function()
      vim.keymap.set('n', '<leader>ff', ':<C-u>Telescope find_files<CR>')
      vim.keymap.set('n', '<leader>fg', ':<C-u>Telescope live_grep<CR>')
      vim.keymap.set('n', '<leader>fb', ':<C-u>Telescope buffers<CR>')
      vim.keymap.set('n', '<leader>;', ':<C-u>Telescope resume<CR>')
    end,
    config = function()
      require 'telescope'.setup {
        defaults = {
          mappings = {
            n = { q = "close" },
          },
        },
      }
    end,
  }
  use { 'nvim-lua/plenary.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
  use {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    setup = function()
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
  }
  use {
    'sbdchd/neoformat',
    cmd = 'Neoformat',
    ft = { 'javascript', 'javascript.jsx', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue' },
    config = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_enabled_javascript = { 'prettier', 'jsbeautify' }
      vim.cmd 'command! -range=% Fmt :mkview | :<line1>,<line2>Neoformat | :loadview'
      vim.cmd [[
      augroup fmt
        autocmd!
        autocmd BufWritePre * Fmt
      augroup END
      ]]
    end
  }
  use {
    -- 'jiangmiao/auto-pairs',
    'LunarWatcher/auto-pairs',
    config = function()
      vim.api.nvim_set_var("AutoPairsCompleteOnlyOnSpace", 1)
      vim.g.AutoPairsCompleteOnlyOnSpace = 1
      vim.g.AutoPairsShortcutJump = ''
      vim.g.AutoPairsShortcutToggle = ''
      vim.g.AutoPairsShortcutToggleMultilineClose = ''
    end
  }
  -- use {
  --   'cohama/lexima.vim',
  --   event = 'InsertEnter',
  --   -- config = function() vim.cmd 'runtime! plugins/lexima.vim' end
  -- }

  use { 'kana/vim-textobj-user', event = 'VimEnter' }
  use {
    'vim-scripts/surround.vim',
    event = 'VimEnter',
    setup = function() vim.keymap.set('n', 's', 'ys', { remap = true }) end
  }

  use {
    'tpope/vim-repeat',
    event = 'VimEnter',
    config = function()
      vim.cmd [[
        function! Execute_repeatable_macro(name)
          const name = '@' .. a:name

          execute 'normal!' name
          silent! call repeat#set("\<Plug>macro_" .. a:name)
        endfunction

        for x in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
          execute 'nnoremap' '<silent>' ("<Plug>macro_" .. x) (":\<C-u>call Execute_repeatable_macro('" .. x .. "')\<CR>")
          execute 'nmap' ('@' .. x) ("<Plug>macro_" .. x)
        endfor
      ]]
    end
  }

  use { 'justinmk/vim-sneak', event = 'VimEnter' }
  use {
    'tomtom/tcomment_vim',
    event = 'VimEnter',
    setup = function()
      vim.cmd [[au MyAutoCmd VimEnter * nnoremap <silent> <Plug>RepeatTComment :TComment \| silent! call repeat#set("\<Plug>RepeatTComment")<CR>]]
      vim.cmd [[au MyAutoCmd VimEnter * nmap <c-_><c-_> <Plug>RepeatTComment]]
    end
  }

  use {
    'nathanaelkane/vim-indent-guides',
    event = 'VimEnter',
    setup = function()
      vim.g.indent_guides_enable_on_vim_startup = 1
      vim.g.indent_guides_auto_colors = 0
      vim.cmd [[autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=none ctermbg=none]]
      vim.cmd [[autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#2e3248 ctermbg=0]]
    end
  }

  -- lsp
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'glepnir/lspsaga.nvim',
    event = 'BufRead',
    config = function()
      require 'lspsaga'.setup {
        finder = {
          keys = {
            jump_to = '<CR>',
            expand_or_jump = '<CR>',
            quit = { 'q', '<ESC>' },
          },
        },
      }
    end
  }
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        enabled = true,
        mapping = cmp.mapping.preset.insert {
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
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
  }
  use { 'hrsh7th/cmp-nvim-lsp', requires = { 'hrsh7th/nvim-cmp' } }
  use { 'hrsh7th/cmp-buffer', requires = { 'hrsh7th/nvim-cmp' } }
  use { 'hrsh7th/cmp-path', requires = { 'hrsh7th/nvim-cmp' } }
  use {
    'neovim/nvim-lspconfig',
    config = function() require 'plugins.lspconfig' end,
    requires = { 'glepnir/lspsaga.nvim', 'hrsh7th/nvim-cmp', 'williamboman/mason-lspconfig.nvim' },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter',
    run = function()
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
  if packer_bootstrap then
    require 'packer'.sync()
  end
end)
