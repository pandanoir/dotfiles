set laststatus=2
set statusline=%f%m%r%h%w%=[ENC=%{&fileencoding}][LOW=%l/%L]
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " 背景色に関する
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
autocmd MyAutoCmd ColorScheme * hi statusline gui=None guibg=#3B4252 guifg=#E5E9F0 cterm=None ctermbg=0 ctermfg=15
autocmd MyAutoCmd ColorScheme * hi Normal guibg=NONE cterm=None ctermbg=none
autocmd MyAutoCmd ColorScheme * hi NonText guibg=NONE cterm=None ctermbg=none

" ファイル名表示
" 変更チェック表示
" 読み込み専用かどうか表示
" ヘルプページなら[HELP]と表示
" プレビューウインドウなら[Prevew]と表示
" これ以降は右寄せ表示
" file encoding
" 現在行数/全行数
