-- 大きいファイル(1MB以上)のパフォーマンス対策。
vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*',
  callback = function()
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.b.large_file = true
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.undofile = false
      vim.opt_local.swapfile = false
    end
  end
})
vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPost' }, {
  pattern = '*',
  callback = function(args)
    if vim.b.large_file then
      vim.cmd 'syntax clear'
      vim.bo.syntax = ''
      vim.treesitter.stop(0) -- highlight.disableでも制御しているが、タイミング次第でTSEnable highlightに上書きされるのでここでも止める

      if vim.bo[args.buf].filetype ~= '' then
        vim.bo[args.buf].filetype = '' -- ts_ls等がattachされないようにfiletypeを空にする
      end
    end
  end
})
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    if vim.b[args.buf].large_file then
      vim.schedule(function()
        vim.lsp.buf_detach_client(args.buf, args.data.client_id) -- filetypeクリアをすり抜けた場合のフォールバック。基本的にあまり発動しない想定
      end)
    end
  end
})
