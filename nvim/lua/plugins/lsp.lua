return {
  {
    'neovim/nvim-lspconfig',
    init = function()
      local nvim_lsp = require 'lspconfig'
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'

      local map = vim.keymap.set
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'qf',
        callback = function()
          map('n', '<CR>', ':<C-u>.cc<CR>:ccl<CR>', { buffer = true })
        end
      })

      map('n', '<leader>e', vim.diagnostic.open_float, { silent = true })
      map('n', '[d', vim.diagnostic.goto_prev, { silent = true })
      map('n', ']d', vim.diagnostic.goto_next, { silent = true })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            group = 'MyAutoCmd',
            callback = function()
              vim.lsp.buf.format()
            end
          })

          local bufopts = { silent = true, buffer = ev.buf }
          map('n', 'gD', vim.lsp.buf.declaration, bufopts)
          map('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', bufopts)
          map('n', 'gt', vim.lsp.buf.type_definition, bufopts)
          map('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', bufopts)
          map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
          map('n', 'gi', vim.lsp.buf.implementation, bufopts)
          map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          map('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          map('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
          map('n', '<leader>r', '<cmd>Lspsaga rename<CR>', bufopts)
          map('n', '<leader>a', '<cmd>Lspsaga code_action<CR>', bufopts)
          map('n', '<leader>F', vim.lsp.buf.format, bufopts)
          map('n', 'gr', '<cmd>Lspsaga finder<CR>', bufopts)
          map('n', '<leader>o', '<cmd>Lspsaga outline<CR>', bufopts)
          vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
          )
        end
      })

      local ensure_installed_ls = {
        'eslint',
        'biome',
        'html',
        'jsonls',
        'tsserver',
        'volar',
        'vimls',
        'rust_analyzer',
        'lua_ls',
      }
      mason.setup {
        log_level = vim.log.levels.DEBUG,
      }
      mason_lspconfig.setup {
        automatic_installation = true,
        ensure_installed = ensure_installed_ls,
      }
      mason_lspconfig.setup_handlers {
        function(server_name)
          nvim_lsp[server_name].setup {}
        end,
        tsserver = function()
          nvim_lsp.tsserver.setup {
            root_dir = nvim_lsp.util.root_pattern('package.json'),
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
      'hrsh7th/nvim-cmp',
      {
        'williamboman/mason.nvim',
        config = true,
        build = ':MasonUpdate'
      },
      'williamboman/mason-lspconfig.nvim'
    },
  },
}
