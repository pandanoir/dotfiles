---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end
vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.scriptencoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-boms,utf-8,euc-jp,cp932' -- 読み込み時の文字コードの自動判別。左ほど優先される
vim.opt.fileformats = 'unix,dos,mac'                  -- 改行コードの自動判別。左ほど優先
vim.g.mapleader = ' '
vim.opt.cursorline = true

require('lazynvim')
require('keymappings')
require('userautoload.indent')
require('userautoload.filetype')

vim.opt.completeopt:append({ insert = false, select = false })
vim.opt.completeopt:remove({ preview = true })

vim.opt.bg = 'dark'
vim.opt.signcolumn = 'yes:3'
vim.opt.mouse = ''
vim.opt.whichwrap = 'b,s,[,],,~'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.scrolloff = 10
vim.opt.guifont = 'Migu 1m:h12'

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  group = 'MyAutoCmd',
  pattern = '*',
  callback = function()
    -- 自動でコメントが入るのを防ぐ
    vim.opt_local.formatoptions:remove('ro')
    -- vim.opt_local.foldmethod = 'indent'
  end
})
-- vim.opt.foldenable = false
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  group = 'MyAutoCmd',
  command = "set timeoutlen=200"
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  group = 'MyAutoCmd',
  command = "set timeoutlen&"
})
-- Don't save options.
vim.opt.viewoptions:remove({ options = true })

vim.opt.backupskip = '/tmp/*,/private/tmp/*,/tmp/crontab.*'
vim.opt.writebackup = false

-- エラー時のビープ音をミュート
vim.opt.visualbell = true

-- " 対応するhtmlタグに % で移動できるようにする
vim.cmd [[packadd! matchit]]
