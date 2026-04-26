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
  { -- TypeScript用のLSP拡張
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        expose_as_code_action = { 'add_missing_imports', 'remove_unused_imports' },
      },
    },
  },
  { -- LSPのUI拡張（定義ジャンプ、ホバー、リネームなど）
    'glepnir/lspsaga.nvim',
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
      -- markdown floatにフォーカスしたらconcealを外して高さをテキスト量に合わせる
      -- cf. https://github.com/neovim/neovim/issues/36537
      vim.api.nvim_create_autocmd('WinEnter', {
        callback = function(ev)
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          -- markdownのフローティングウィンドウかをチェック
          if cfg.relative == '' or vim.bo[ev.buf].filetype ~= 'markdown' then
            return
          end
          vim.wo[win].conceallevel = 0
          local new_height = math.min(vim.api.nvim_win_text_height(win, {}).all, math.floor(vim.o.lines * 0.8))
          if new_height ~= cfg.height then
            cfg.height = new_height
            vim.api.nvim_win_set_config(win, cfg)
          end
        end,
      })
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local map = vim.keymap.set
          local opt = function(desc)
            return { silent = true, buffer = ev.buf, desc = desc }
          end
          map('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', opt('go to definition'))
          map('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>', opt('go to type definition'))
          map('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', opt('peek definition'))
          map('n', 'grr', '<cmd>Lspsaga finder<CR>', opt())
          map('n', 'K', function()
            vim.lsp.buf.hover({ border = 'rounded' })
          end, opt())
          map('n', 'grn', '<cmd>Lspsaga rename<CR>', opt('rename using LSP'))
          map('n', 'gra', '<cmd>Lspsaga code_action<CR>', opt('open code action'))
          map('n', '<leader>o', '<cmd>Lspsaga outline<CR>', opt('show outline'))
        end
      })
    end
  },
  { -- Lua開発用のLSP補助
    'folke/lazydev.nvim',
    ft = 'lua',
    config = true,
  },
}
