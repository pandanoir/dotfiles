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
nnoremap s- :<C-u>sp<CR>
nnoremap s\| :<C-u>vs<CR>

nnoremap J gJ

" for masui special.
nnoremap <CR> :<C-u>w<CR>
" qでウインドウを閉じて Qでマクロ
nnoremap q :<C-u>q<CR>
nnoremap Q q

nnoremap ; :
nnoremap : ;

vnoremap ; :
vnoremap : ;

"削除時にヤンクしない
nnoremap x "_x
nnoremap X "_X

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

inoremap <silent> jj <Esc>
inoremap <silent> fd <Esc>

inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>

cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

let mapleader = ","

" ,のデフォルトの機能は、\で使えるように退避
noremap \  ,

noremap [space] <nop>
nmap <Space> [space]
noremap [space]c :<C-u>enew<CR>
noremap [space]d :<C-u>bd<CR>

