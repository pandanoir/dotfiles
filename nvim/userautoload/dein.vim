" dein.vimのディレクトリ
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath= s:dein_repo_dir . ',' . &runtimepath

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:toml = s:config_home . '/nvim/rc/dein.toml'
    let s:lazy_toml = s:config_home . '/nvim/rc/deinlazy.toml'
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif
if has('vim_starting') && dein#check_install()
    call dein#install()
endif
