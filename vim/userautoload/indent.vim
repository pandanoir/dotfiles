"インデントの設定
filetype on
filetype plugin on
set tabstop=4 autoindent expandtab shiftwidth=4 softtabstop=4
autocmd MyAutoCmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd MyAutoCmd BufRead,BufNewFile *.ts set filetype=typescript
