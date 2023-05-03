---@diagnostic disable-next-line: undefined-global
vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })
vim.cmd [[filetype off]]
vim.cmd [[filetype plugin indent off]]

vim.opt.termguicolors = true
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = vim.fn.system(
  'echo -n $(if which python3 &>/dev/null; then which python3; else which python3.6; fi)'
)
vim.g.cache_home = vim.env.XDG_CACHE_HOME or vim.fn.expand('~/.cache')
vim.g.config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand('~/.config')

vim.opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-boms,utf-8,euc-jp,cp932' -- 読み込み時の文字コードの自動判別。左ほど優先される
vim.opt.fileformats = 'unix,dos,mac'                  -- 改行コードの自動判別。左ほど優先
vim.opt.ambiwidth = 'double'                          -- ◻︎や◯がくずれるのを対処

require('plugins')
require('keymappings.basic')
require('keymappings.vim-sneak')
require('userautoload.indent')
require('userautoload.filetype')

vim.opt.completeopt:append({ insert = false, select = false })
vim.opt.completeopt:remove({ preview = true })
vim.opt.iskeyword:append('_')

vim.opt.hidden = true -- バッファ切り替え時に保存しなくてもよくする
vim.opt.autoread = true

vim.env.DOTVIM = vim.g.config_home .. '/nvim'
vim.opt.backspace = 'start,eol,indent'
vim.opt.whichwrap = 'b,s,[,],,~'

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.autoindent = true
vim.opt.scrolloff = 10
vim.opt.guifont = 'Migu 1m:h12'
vim.cmd [[syntax on]]

-- 自動でコメントが入るのを防ぐ
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  group = 'MyAutoCmd',
  pattern = '*',
  command = "setlocal formatoptions-=ro"
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'MyAutoCmd',
  pattern = '*',
  command = "set foldmethod=marker"
})

-- Save fold settings.
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = 'MyAutoCmd',
  pattern = '*',
  command = "if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif"
})
vim.api.nvim_create_autocmd({ 'BufRead' }, {
  group = 'MyAutoCmd',
  pattern = '*',
  command = "if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif"
})
-- Don't save options.
vim.opt.viewoptions:remove({ options = true })

vim.opt.backupskip = '/tmp/*,/private/tmp/*,/tmp/crontab.*'
vim.opt.writebackup = false

-- エラー時のビープ音をミュート
vim.opt.visualbell = true
vim.o.t_vb = nil

-- " 対応するhtmlタグに % で移動できるようにする
vim.cmd [[packadd! matchit]]
--
vim.g.jsx_ext_required = 1
vim.cmd [[filetype plugin indent on]]
