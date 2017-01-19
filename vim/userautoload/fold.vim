" 折りたたみ機能を使う
" http://nanasi.jp/articles/howto/fold/fold-marker.html
set foldmethod=marker
let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML
hi Folded gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey30 guifg=Grey80
hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue

"foldの設定
" set foldtext=FoldCCtext()
set foldcolumn=5
set fillchars=vert:\|
