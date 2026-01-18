return {
  { -- nvim-lspconfig の設定を利用してlanguage serverの起動、セットアップをする、masonを介してlanguage serverの自動インストールもする
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        'denols',
        'eslint',
        'html',
        'jsonls',
        'lua_ls',
        'rust_analyzer',
        'ts_ls',
        'vimls',
        'vue_ls',
      },
    },
    dependencies = {
      { -- エディタツールを管理するパッケージマネージャー
        'williamboman/mason.nvim',
        opts = {}
      },
      { -- コンフィグ集
        'neovim/nvim-lspconfig',
      },
    }
  },
  { -- LSPのUI拡張（定義ジャンプ、ホバー、リネームなど）
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
  { -- Lua開発用のLSP補助
    'folke/lazydev.nvim',
    ft = 'lua',
    config = true,
  },
}
