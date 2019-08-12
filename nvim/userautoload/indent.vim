"インデントの設定
filetype on
filetype plugin on
set tabstop=4 autoindent expandtab shiftwidth=4 softtabstop=4
autocmd MyAutoCmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd MyAutoCmd FileType pug setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd MyAutoCmd FileType cpp setlocal shiftwidth=2 tabstop=2 softtabstop=2
"htmlのインデント設定
let g:html5_event_handler_attributes_complete = 1
let g:html5_rdfa_attributes_complete = 1
let g:html5_microdata_attributes_complete = 1
let g:html5_aria_attributes_complete = 1
