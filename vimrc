filetype off
filetype plugin indent off

let $DOTVIM = $HOME . '/.vim'
set runtimepath+=~/.vim/
runtime! userautoload/*.vim
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
augroup auto_comment_off
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=r
    autocmd BufEnter * setlocal formatoptions-=o
augroup END


set clipboard=unnamed,autoselect number backupskip=/tmp/*,/private/tmp/*,/tmp/crontab.* nowritebackup

" 未保存でもバッファを切り替えられるように
set hidden

" HTMLの閉じタグ補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" エラー時のビープ音をミュート
set visualbell t_vb= noerrorbells

" _gvimrc で定義する
" 波線で表示する場合は、以下の設定を行う
" エラーを赤字の波線で
execute "highlight qf_error_ucurl gui=undercurl guisp=Red"
let g:hier_highlight_group_qf  = "qf_error_ucurl"
" 警告を青字の波線で
execute "highlight qf_warning_ucurl gui=undercurl guisp=Blue"
let g:hier_highlight_group_qfw = "qf_warning_ucurl"

filetype plugin indent on     " Required!
