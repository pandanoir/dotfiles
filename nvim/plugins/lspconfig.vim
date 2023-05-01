set signcolumn=yes
autocmd FileType qf nnoremap <buffer> <CR> :<C-u>.cc<CR>:ccl<CR>
lua << EOF
local ensure_installed_ls = {'eslint', 'html', 'jsonls', 'tsserver', 'volar'}
require("mason").setup()
require("mason-lspconfig").setup{
  automatic_installation = true,
  ensure_installed = ensure_installed_ls,
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', bufopts)
  vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>r', '<cmd>Lspsaga rename<CR>', bufopts)
  vim.keymap.set('n', '<space>a',  '<cmd>Lspsaga code_action<CR>', bufopts)
  vim.keymap.set('n', 'gr',  '<cmd>Lspsaga lsp_finder<CR>', bufopts)
  vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', bufopts)
  vim.keymap.set('n', '<space>o',  '<cmd>Lspsaga outline<CR>', bufopts)
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
  )
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')
nvim_lsp.tsserver.setup{
  on_attach = on_attach,
  flags = lsp_flags,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  capabilities = capabilities,
}
nvim_lsp.denols.setup{
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("deno.json"),
  capabilities = capabilities,
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
}
local local_installed_ls = {'vimls', 'rust_analyzer', 'lua_ls'}
for _,lsp in pairs(local_installed_ls) do
  nvim_lsp[lsp].setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
for _,lsp in pairs(ensure_installed_ls) do
  if lsp ~= 'tsserver' then
    nvim_lsp[lsp].setup{
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end
EOF
