filetype off
filetype plugin indent off

let g:python_host_prog  = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別。左ほど優先される
set fileformats=unix,dos,mac " 改行コードの自動判別。左ほど優先
set ambiwidth=double "◻︎や◯がくずれるのを対処

set runtimepath+=~/.config/nvim
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/deoplete.nvim
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/neosnippet
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets
runtime! userautoload/*.vim

set completeopt+=noinsert,noselect
set completeopt-=preview

set hidden " バッファ切り替え時に保存しなくてもよくする

let $DOTVIM = $HOME . '/.config/nvim'
set backspace=start,eol,indent
set whichwrap=b,s,[,],,~
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources = ["neosnippet"]
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ["neosnippet"]

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets'

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
set background=dark
" source $VIMRUNTIME/macros/matchit.vim
" ヤンク時にクリップボードへコピー
set clipboard+=unnamedplus


"自動でコメントが入るのを防ぐ
augroup auto_comment_off
	autocmd!
	autocmd BufEnter * setlocal formatoptions-=r
	autocmd BufEnter * setlocal formatoptions-=o
augroup END

set number
set backupskip=/tmp/*,/private/tmp/*
set nowritebackup
autocmd BufRead /tmp/crontab.* :set nobackup nowritebackup
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1
"simple javascript indenterの設定
let g:neosnippet#disable_runtime_snippets = { "_": 1, }


"multi_cursor
let g:multi_cursor_start_key='<C-n>'
let g:multi_cursor_start_word_key='g<C-n>'

" HTMLの閉じタグ補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

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
call remote#host#RegisterPlugin('python3', '/home/shougo/.nvim/rplugin/python3/snake.py', [
      \ {'sync': 1, 'name': 'SnakeStart', 'type': 'command', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', '/home/shougo/work/deoplete.nvim/rplugin/python3/deoplete.py', [
      \ {'sync': 1, 'name': 'DeopleteInitializePython', 'type': 'command', 'opts': {}},
     \ ])


" python plugins
filetype plugin indent on     " Required!
