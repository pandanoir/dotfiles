let g:beautify#beautifier#npm_beautifier#bin = {
    \ 'javascript' : 'js-beautify'}


colorscheme jellybeans
set cursorline
hi CursorLine ctermfg=0 ctermbg=243
hi Folded ctermfg=255 ctermbg=25

" Unite
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200

" Emmet
let g:user_emmet_settings = {
\    'variables' : {
\        'lang' : 'ja',
\    },
\    'html' : {
\        'snippets'   : {
\            'html:5': "<!DOCTYPE html>\n"
\                    ."<html lang=\"${lang}\">\n"
\                    ."<meta charset=\"${charset}\">\n"
\                    ."<title></title>\n"
\                    ."${child}|\n",
\            'meta:ip': '<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">',
\        }
\    }
\}
autocmd FileType javascript,coffee setlocal omnifunc=javascriptcomplete#CompleteJS
call lexima#add_rule({'char': '(', 'at': '\%#\w'})
call lexima#add_rule({'char': '[', 'at': '\%#\w'})
call lexima#add_rule({'char': '"', 'at': '\%#\w'})
call lexima#add_rule({'char': "'", 'at': '\%#\w'})
call lexima#add_rule({'char': '`', 'at': '\%#\w'})
