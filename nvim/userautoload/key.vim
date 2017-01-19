imap <C-d> <C-y>,

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

" nnoremap <silent> ,f :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
" nnoremap <silent> ,b :<C-u>Unite buffer<CR>

nnoremap <silent> ,f :<C-u>Denite file_rec -mode=normal<CR>
nnoremap <silent> ,b :<C-u>Denite buffer -mode=normal<CR>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

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

inoremap <silent> jj <Esc>

let mapleader = ","

" ,のデフォルトの機能は、\で使えるように退避
noremap \  ,

noremap <Space>h  ^
noremap <Space>l  $

noremap [space] <nop>
nmap <Space> [space]
noremap [space]c :<C-u>enew<CR>

"**************************************************
" <Space>* によるキーバインド設定
"**************************************************

" <Space>i でコードをインデント整形
map <Space>i gg=<S-g><C-o><C-o>zz

" <Space>v で1行選択(\n含まず)
noremap <Space>v 0v$h

" <Space>d で1行削除(\n含まずに dd)
noremap <Space>d 0v$hx

" <Space>y で改行なしで1行コピー(\n を含まずに yy)
noremap <Space>y 0v$hy

" <Space>s で置換
noremap <Space>s :%s/


command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" <Space>cd で編集ファイルのカレントディレクトリへと移動
nnoremap <silent> <Space>cd :<C-u>CD<CR>
