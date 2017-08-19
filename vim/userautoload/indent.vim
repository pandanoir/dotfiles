"インデントの設定
filetype on
filetype plugin on
autocmd BufRead,BufNewFile *.ts set filetype=typescript
augroup vimrc
    autocmd! FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END
set tabstop=4 autoindent expandtab shiftwidth=4 softtabstop=4
