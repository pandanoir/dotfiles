vim.scriptencoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-boms,utf-8,euc-jp,cp932' -- 読み込み時の文字コードの自動判別。左ほど優先される
vim.opt.fileformats = 'unix,dos,mac'                  -- 改行コードの自動判別。左ほど優先
vim.g.mapleader = ' '
vim.opt.cursorline = true
vim.opt.bg = 'dark'
vim.opt.signcolumn = 'yes:3'
vim.opt.mouse = ''
vim.opt.whichwrap = 'b,s,[,],,~'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.scrolloff = 10
-- Don't save options.
vim.opt.viewoptions:remove({ options = true })

vim.opt.backupskip = '/tmp/*,/private/tmp/*,/tmp/crontab.*'
vim.opt.writebackup = false

-- エラー時のビープ音をミュート
vim.opt.visualbell = true

-- カーソル行のdiagnosticだけ表示する
vim.diagnostic.config({
  virtual_text = { current_line = true }
})

vim.g.markdown_recommended_style = 0 -- デフォルトだとshiftwidth=4などが設定されるので無効にする

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.cmd [[filetype plugin on]]

-- 大きいファイル(1MB以上)のパフォーマンス対策。
require 'easy-setup-autocmd'.setup_autocmd {
  ['BufReadPre'] = {
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
  },
  ['FileType,BufReadPost'] = {
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
  },
  ['LspAttach'] = {
    callback = function(args)
      if vim.b[args.buf].large_file then
        vim.schedule(function()
          vim.lsp.buf_detach_client(args.buf, args.data.client_id) -- filetypeクリアをすり抜けた場合のフォールバック。基本的にあまり発動しない想定
        end)
      end
    end
  },
}

require 'easy-setup-autocmd'.setup_autocmd {
  ['BufEnter,FileType'] = {
    pattern = '*',
    callback = function()
      -- 自動でコメントが入るのを防ぐ
      vim.opt_local.formatoptions:remove('ro')
    end
  },
  ['ColorScheme'] = {
    pattern = '*',
    callback = require 'improve-default-scheme'.improve
  }
}
