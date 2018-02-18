imap <C-d> <C-y>,

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sc <C-w>c<CR>
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sQ :<C-u>bd<CR>

nnoremap 1<CR> :<C-u>w !sudo tee %<CR>

nnoremap J gJ

" for masui special.
nnoremap <CR> :<C-u>w<CR>
" qでウインドウを閉じて Qでマクロ
nnoremap q :<C-u>q<CR>
nnoremap Q q

nnoremap <C-q> <C-w><C-w>:<C-u>q<CR>

nnoremap ; :
nnoremap : ;

vnoremap ; :
vnoremap : ;

nnoremap x "_x
nnoremap X "_X
"削除時にヤンクしない

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

inoremap <silent> jj <Esc>

let mapleader = ","

" ,のデフォルトの機能は、\で使えるように退避
noremap \  ,

noremap <Space>h  ^
noremap <Space>l  $

noremap [space] <nop>
nmap <Space> [space]
noremap [space]c :<C-u>enew<CR>
