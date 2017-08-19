" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

filetype off
filetype plugin indent off

let g:python_host_prog  = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別。左ほど優先される
set fileformats=unix,dos,mac " 改行コードの自動判別。左ほど優先
set ambiwidth=double "◻︎や◯がくずれるのを対処

let &runtimepath=$config_home . '/nvim' . ',' . &runtimepath
runtime! userautoload/*.vim

set completeopt+=noinsert,noselect
set completeopt-=preview

set hidden " バッファ切り替え時に保存しなくてもよくする

let $DOTVIM = $config_home . '/nvim'
set backspace=start,eol,indent
set whichwrap=b,s,[,],,~

set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <C-k><C-k> :set nohlsearch!<CR><Esc>

set timeoutlen=300

set wildmenu wildmode=list:full
set autoindent
set scrolloff=10
set guifont=Migu\ 1m:h12
syntax on
" ヤンク時にクリップボードへコピー
set clipboard+=unnamedplus


"自動でコメントが入るのを防ぐ
augroup auto_comment_off
	autocmd!
	autocmd BufEnter * setlocal formatoptions-=r
	autocmd BufEnter * setlocal formatoptions-=o
augroup END

set number
set backupskip=/tmp/*,/private/tmp/*,/tmp/crontab.*
set nowritebackup

" エラー時のビープ音をミュート
set visualbell t_vb=
set noerrorbells

" _gvimrc で定義する
" 波線で表示する場合は、以下の設定を行う
" エラーを赤字の波線で
execute "highlight qf_error_ucurl gui=undercurl guisp=Red"
let g:hier_highlight_group_qf  = "qf_error_ucurl"
" 警告を青字の波線で
execute "highlight qf_warning_ucurl gui=undercurl guisp=Blue"
let g:hier_highlight_group_qfw = "qf_warning_ucurl"

" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/shougo/.nvim/rplugin/python3/snake.py', [{'sync': 1, 'name': 'SnakeStart', 'type': 'command', 'opts': {}},])
call remote#host#RegisterPlugin('python3', '/home/shougo/work/deoplete.nvim/rplugin/python3/deoplete.py', [{'sync': 1, 'name': 'DeopleteInitializePython', 'type': 'command', 'opts': {}},])

" python plugins
filetype plugin indent on     " Required!
