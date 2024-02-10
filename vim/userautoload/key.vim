let mapleader = " "

noremap [space] <nop>
nmap <Space> [space]

nnoremap J gJ

nnoremap <CR> :<C-u>w<CR>

nnoremap <C-k><C-k> :set nohlsearch!<CR><Esc>

" qでウインドウを閉じて Qでマクロ
nnoremap q :<C-u>q<CR>
nnoremap Q q

nnoremap gy "+y
nnoremap <leader>d "_d

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" クリップボードへコピー
nnoremap <leader>y "*y
nnoremap <leader>p "0p

imap <silent> fd <Esc>

inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>

nnoremap <C-n>       :bnext<CR>
nnoremap <C-p>       :bprev<CR>

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

" %% でアクティブなファイルが含まれているディレクトリを手早く展開
cnoremap <expr> %% getcmdtype() == ":" ? expand("%:h")."/" : "%%"
