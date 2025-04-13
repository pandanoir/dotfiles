local ensure_installed = {
  'denols',
  'eslint',
  'html',
  'jsonls',
  'lua_ls',
  'rust_analyzer',
  'ts_ls',
  'vimls',
  'volar',
}

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    config = true,
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
  -- language serverのインストールと設定を行う
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      automatic_installation = true,
      ensure_installed = ensure_installed,
    },
    init = function()
      vim.lsp.config('ts_ls', {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      })

      -- typescript-language-serverとdeno-lspの競合を回避する
      local nvim_lsp = require 'lspconfig'
      local is_node_dir = function()
        return nvim_lsp.util.root_pattern('package.json')(vim.fn.getcwd())
      end
      vim.lsp.config('ts_ls', {
        on_attach = function(client)
          if not is_node_dir() then
            client.stop(true)
          end
        end
      })
      vim.lsp.config('denols', {
        on_attach = function(client)
          if is_node_dir() then
            client.stop(true)
          end
        end
      })

      vim.lsp.enable(ensure_installed)
    end,
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = true,
        build = ':MasonUpdate',
      },
      'neovim/nvim-lspconfig',
    }
  },
}
