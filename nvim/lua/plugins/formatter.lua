return {
  'sbdchd/neoformat',
  cmd = 'Neoformat',
  ft = { 'javascript', 'javascript.jsx', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue' },
  init = function()
    vim.g.neoformat_try_node_exe = 1
    vim.g.neoformat_enabled_javascript = { 'prettier', 'jsbeautify' }
    vim.cmd 'command! -range=% Fmt :mkview | :<line1>,<line2>Neoformat | :loadview'
    vim.cmd [[augroup fmt autocmd! autocmd BufWritePre * Fmt augroup END]]
  end
}
