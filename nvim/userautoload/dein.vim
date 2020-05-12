" dein.vimのディレクトリ
let s:dein_dir = g:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath= s:dein_repo_dir . ',' . &runtimepath

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(g:config_home . '/nvim/rc/dein.toml', {'lazy': 0})
    call dein#load_toml(g:config_home . '/nvim/rc/deinlazy.toml', {'lazy': 1})
    call dein#load_toml(g:config_home . '/nvim/rc/deinlang.toml', {'lazy': 1})
    call dein#end()
    call dein#save_state()
    " call dein#recache_runtimepath()
endif
if has('vim_starting') && dein#check_install()
    call dein#install()
endif
