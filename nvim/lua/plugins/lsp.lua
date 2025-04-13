return {
  {
    'neovim/nvim-lspconfig',
    init = function()
      local nvim_lsp = require 'lspconfig'
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'

      -- カーソル行のdiagnosticだけ表示する
      vim.diagnostic.config({
        virtual_text = { current_line = true }
      })
      local map = vim.keymap.set
      map('n', '<leader>e', vim.diagnostic.open_float,
        { silent = true, desc = 'show diagnostics in a floating window' })
      require 'easy-setup-autocmd'.setup_autocmd {
        ['FileType'] = {
          pattern = 'qf',
          callback = function()
            map('n', '<CR>', ':<C-u>.cc<CR>:ccl<CR>', { buffer = true })
          end
        },
        ['LspAttach'] = {
          callback = function(ev)
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            local bufopts = { silent = true, buffer = ev.buf }
            local optWithDesc = function(desc)
              return vim.tbl_extend('force', { desc = desc }, bufopts)
            end
            map('n', 'gD', vim.lsp.buf.declaration, bufopts)
            map('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', bufopts)
            map('n', 'gt', vim.lsp.buf.type_definition, bufopts)
            map('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', bufopts)
            map('n', 'gr', '<cmd>Lspsaga finder<CR>', bufopts)
            map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
            map('n', 'gi', vim.lsp.buf.implementation, bufopts)
            map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            map('n', '<leader>r', '<cmd>Lspsaga rename<CR>', optWithDesc('rename using LSP'))
            map('n', '<leader>a', '<cmd>Lspsaga code_action<CR>', optWithDesc('open code action'))
            map('n', '<leader>o', '<cmd>Lspsaga outline<CR>', optWithDesc('show outline'))
            vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
              vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
            )
          end
        }
      }

      mason.setup {
        log_level = vim.log.levels.DEBUG,
      }
      mason_lspconfig.setup {
        automatic_installation = true,
        ensure_installed = {
          'eslint',
          'html',
          'jsonls',
          'ts_ls',
          'volar',
          'vimls',
          'rust_analyzer',
          'lua_ls',
        },
      }

      local disable_formatting = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
      mason_lspconfig.setup_handlers {
        function(server_name)
          nvim_lsp[server_name].setup {}
        end,
        ts_ls = function()
          nvim_lsp.ts_ls.setup {
            root_dir = nvim_lsp.util.root_pattern('package.json'),
            on_attach = disable_formatting
          }
        end,
        denols = function()
          nvim_lsp.denols.setup {
            root_dir = nvim_lsp.util.root_pattern('deno.json'),
            init_options = {
              lint = true,
              unstable = true,
              suggest = {
                imports = {
                  hosts = {
                    ['https://deno.land'] = true,
                    ['https://cdn.nest.land'] = true,
                    ['https://crux.land'] = true,
                  },
                },
              },
            },
          }
        end
      }
    end,
    event = 'BufRead',
    dependencies = {
      {
        'folke/neodev.nvim',
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
      },
      {
        'williamboman/mason.nvim',
        config = true,
        build = ':MasonUpdate'
      },
      'williamboman/mason-lspconfig.nvim',
    },
  },
}
