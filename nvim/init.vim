" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

filetype off
filetype plugin indent off

let g:python_host_prog  = system('echo -n $(which python)')
let g:python3_host_prog = system('echo -n $(if which python3 &>/dev/null; then which python3; else which python3.6; fi)')
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別。左ほど優先される
set fileformats=unix,dos,mac " 改行コードの自動判別。左ほど優先
set ambiwidth=double "◻︎や◯がくずれるのを対処

let &runtimepath=$config_home . '/nvim' . ',' . &runtimepath
runtime! userautoload/*.vim

set completeopt+=noinsert,noselect
set completeopt-=preview

set hidden " バッファ切り替え時に保存しなくてもよくする

let $DOTVIM = $config_home . '/nvim'
set backspace=start,eol,indent whichwrap=b,s,[,],,~

set incsearch ignorecase smartcase hlsearch
nnoremap <C-k><C-k> :set nohlsearch!<CR><Esc>

set timeoutlen=300

set wildmenu wildmode=list:full autoindent scrolloff=10 guifont=Migu\ 1m:h12
syntax on

"自動でコメントが入るのを防ぐ
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=r
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=o

autocmd MyAutoCmd BufRead,BufNewFile {,.}{zprofile,zshrc}{,.local} set ft=zsh

set number backupskip=/tmp/*,/private/tmp/*,/tmp/crontab.* nowritebackup

" エラー時のビープ音をミュート
set visualbell t_vb= noerrorbells

set rtp+=~/.fzf

if &shell =~# 'fish$'
    set shell=sh
endif

" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/shougo/.nvim/rplugin/python3/snake.py', [{'sync': 1, 'name': 'SnakeStart', 'type': 'command', 'opts': {}},])
call remote#host#RegisterPlugin('python3', '/home/shougo/work/deoplete.nvim/rplugin/python3/deoplete.py', [{'sync': 1, 'name': 'DeopleteInitializePython', 'type': 'command', 'opts': {}},])

" python plugins
filetype plugin indent on     " Required!
