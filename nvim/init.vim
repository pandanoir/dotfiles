" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

filetype off
filetype plugin indent off

set termguicolors
let g:loaded_python_provider = 0
let g:python3_host_prog = system('echo -n $(if which python3 &>/dev/null; then which python3; else which python3.6; fi)')

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別。左ほど優先される
set fileformats=unix,dos,mac " 改行コードの自動判別。左ほど優先
" set ambiwidth=double "◻︎や◯がくずれるのを対処

let &runtimepath=$config_home . '/nvim' . ',' . &runtimepath
runtime! userautoload/stopdefaultplugins.vim
runtime! userautoload/dein.vim
runtime! userautoload/cpp.vim
runtime! userautoload/indent.vim
runtime! userautoload/key.vim

set completeopt+=noinsert,noselect
set completeopt-=preview

" set iskeyword-=_

set hidden " バッファ切り替え時に保存しなくてもよくする
set autoread

let $DOTVIM = $config_home . '/nvim'
set backspace=start,eol,indent whichwrap=b,s,[,],,~

set incsearch ignorecase smartcase hlsearch
nnoremap <C-k><C-k> :set nohlsearch!<CR><Esc>

set timeoutlen=300

set wildmenu wildmode=list:full autoindent scrolloff=10 guifont=Migu\ 1m:h12
syntax on

"自動でコメントが入るのを防ぐ
autocmd MyAutoCmd BufEnter,FileType * setlocal formatoptions-=ro
autocmd MyAutoCmd BufRead,BufNewFile *.c set foldmethod=marker

" Save fold settings.
set foldmethod=indent
set foldlevel=99 " 最初は全部開いておく
autocmd MyAutoCmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd MyAutoCmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
" Don't save options.
set viewoptions-=options

" set number
set backupskip=/tmp/*,/private/tmp/*,/tmp/crontab.* nowritebackup

" エラー時のビープ音をミュート
set visualbell t_vb= noerrorbells

let g:jsx_ext_required = 1

runtime! userautoload/filetype.vim

filetype plugin indent on     " Required!

