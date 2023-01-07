nnoremap J gJ

" for masui special.
nnoremap <CR> :<C-u>w<CR>

nnoremap <C-k><C-k> :set nohlsearch!<CR><Esc>

" qでウインドウを閉じて Qでマクロ
nnoremap q :<C-u>q<CR>
nnoremap Q q

nnoremap ; :

vmap ; :

"削除時にヤンクしない
nnoremap x "_x
nnoremap X "_X
nnoremap gy "+y
vnoremap gy "+y

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

imap <silent> fd <Esc>

inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>

cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

nnoremap <C-n>       :bnext<CR>
nnoremap <C-p>       :bprev<CR>

let mapleader = ","

" ,のデフォルトの機能は、\で使えるように退避
noremap \  ,

noremap [space] <nop>
nmap <Space> [space]
noremap [space]c :<C-u>enew<CR>
noremap [space]d :<C-u>bd<CR>

