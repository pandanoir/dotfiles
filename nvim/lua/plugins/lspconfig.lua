local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'

vim.cmd [[set signcolumn=yes]]
vim.cmd [[autocmd FileType qf nnoremap <buffer> <CR> :<C-u>.cc<CR>:ccl<CR>]]

local opts = { noremap = true, silent = true }
local map = vim.keymap.set
map('n', '<space>e', vim.diagnostic.open_float, opts)
map('n', '[d', vim.diagnostic.goto_prev, opts)
map('n', ']d', vim.diagnostic.goto_next, opts)
map('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  map('n', 'gD', vim.lsp.buf.declaration, bufopts)
  map('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', bufopts)
  map('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  map('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', bufopts)
  map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
  map('n', 'gi', vim.lsp.buf.implementation, bufopts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  map('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  map('n', '<space>r', '<cmd>Lspsaga rename<CR>', bufopts)
  map('n', '<space>a', '<cmd>Lspsaga code_action<CR>', bufopts)
  map('n', 'gr', '<cmd>Lspsaga lsp_finder<CR>', bufopts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', bufopts)
  map('n', '<space>o', '<cmd>Lspsaga outline<CR>', bufopts)
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
  )
end

local ensure_installed_ls = {
  'eslint',
  'html',
  'jsonls',
  'tsserver',
  'volar',
  -- 'vimls',
  -- 'rust_analyzer',
  -- 'lua_ls',
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
    nvim_lsp[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  tsserver = function()
    nvim_lsp.tsserver.setup {
      on_attach = on_attach,
      root_dir = nvim_lsp.util.root_pattern('package.json'),
      capabilities = capabilities,
    }
  end,
  denols = function()
    nvim_lsp.denols.setup {
      on_attach = on_attach,
      root_dir = nvim_lsp.util.root_pattern('deno.json'),
      capabilities = capabilities,
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
