set laststatus=2
set statusline=%F%m%r%h%w%=[ENC=%{&fileencoding}][LOW=%l/%L]
autocmd MyAutoCmd ColorScheme * highlight statusline ctermfg=blue ctermbg=white guifg=blue guibg=white

" ファイル名表示
" 変更チェック表示
" 読み込み専用かどうか表示
" ヘルプページなら[HELP]と表示
" プレビューウインドウなら[Prevew]と表示
" これ以降は右寄せ表示
" file encoding
" 現在行数/全行数
