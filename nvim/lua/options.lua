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
