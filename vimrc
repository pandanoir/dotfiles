filetype off
filetype plugin indent off
augroup MyAutoCmd
    autocmd!
augroup END

let $DOTVIM = $HOME . '/.vim'
set runtimepath+=~/.vim/,$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
runtime! userautoload/*.vim

set directory=$XDG_CACHE_HOME/vim,~/,/tmp
set backupdir=$XDG_CACHE_HOME/vim,~/,/tmp
set viminfo+='1000,n$XDG_CACHE_HOME/vim/viminfo
set runtimepath+=$XDG_CONFIG_HOME/vim,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after

set timeoutlen=400 "http://calcurio.com/wordpress/?p=1076

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別。左ほど優先される
set fileformats=unix,dos,mac " 改行コードの自動判別。左ほど優先
set ambiwidth=double "◻︎や◯がくずれるのを対処

set backspace=start,eol,indent whichwrap=b,s,[,],,~

colorscheme desert
set wildmenu wildmode=list:full autoindent scrolloff=10 guifont=Migu\ 1m:h12
syntax on

set incsearch ignorecase smartcase hlsearch
nnoremap <C-k><C-k> :set nohlsearch!<CR><Esc>

"自動でコメントが入るのを防ぐ
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=r
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=o
" HTMLの閉じタグ補完
autocmd MyAutoCmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
autocmd MyAutoCmd Filetype html inoremap <buffer> </ </<C-x><C-o>

set clipboard=unnamed,autoselect number backupskip=/tmp/*,/private/tmp/*,/tmp/crontab.* nowritebackup

" 未保存でもバッファを切り替えられるように
set hidden

" エラー時のビープ音をミュート
set visualbell t_vb= noerrorbells

filetype plugin indent on     " Required!
