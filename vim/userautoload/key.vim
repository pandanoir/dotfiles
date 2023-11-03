let mapleader = " "
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
nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" クリップボードへコピー
nnoremap <leader>y "*y
vnoremap <leader>y "*y

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

" ,のデフォルトの機能は、\で使えるように退避

noremap [space] <nop>
nmap <Space> [space]
noremap <leader>c :<C-u>enew<CR>
noremap <leader>q :<C-u>bd<CR>
noremap <leader><Space> <C-v>

" 貼り付けたテキストを素早く選択する
noremap gv `[v`] 

" 貼り付けたテキストの末尾へ自動的に移動する
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" :s<Space> で:%s//|/g にする cf. https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
