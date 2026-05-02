return {
  { -- nvim-lspconfig の設定を利用してlanguage serverの起動、セットアップをする、masonを介してlanguage serverの自動インストールもする
    'williamboman/mason-lspconfig.nvim',
    cond = not require('env').is_ci,
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
  { -- Lua開発用のLSP補助
    'folke/lazydev.nvim',
    ft = 'lua',
    config = true,
  },
}
