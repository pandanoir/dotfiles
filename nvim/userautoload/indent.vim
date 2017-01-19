"インデントの設定
filetype on
filetype plugin on
autocmd BufRead,BufNewFile *.ts set filetype=typescript
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
augroup vimrc
    autocmd! FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END
"htmlのインデント設定
let g:html5_event_handler_attributes_complete = 1
let g:html5_rdfa_attributes_complete = 1
let g:html5_microdata_attributes_complete = 1
let g:html5_aria_attributes_complete = 1
