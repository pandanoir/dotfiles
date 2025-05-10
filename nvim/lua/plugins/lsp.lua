return {
  -- language serverのインストールと設定を行う
  {
    'williamboman/mason.nvim',
    config = true,
    build = ':MasonUpdate',
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      automatic_installation = true,
      ensure_installed = {
        'denols',
        'eslint',
        'html',
        'jsonls',
        'lua_ls',
        'rust_analyzer',
        'ts_ls',
        'vimls',
        'volar',
      },
    },
    init = function()
      vim.lsp.enable(require 'mason-lspconfig'.get_installed_servers())
    end,
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    }
  },

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
      symbol_in_winbar = {
        enable = false
      },
    },
    init = function()
      require 'easy-setup-autocmd'.setup_autocmd {
        ['LspAttach'] = {
          callback = function(ev)
            local map = vim.keymap.set
            local opt = function(desc)
              return { silent = true, buffer = ev.buf, desc = desc }
            end
            map('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', opt())
            map('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', opt())
            map('n', 'grr', '<cmd>Lspsaga finder<CR>', opt())
            map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opt())
            map('n', 'grn', '<cmd>Lspsaga rename<CR>', opt('rename using LSP'))
            map('n', 'gra', '<cmd>Lspsaga code_action<CR>', opt('open code action'))
            map('n', '<leader>o', '<cmd>Lspsaga outline<CR>', opt('show outline'))
          end
        }
      }
    end
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    config = true,
  },
}
