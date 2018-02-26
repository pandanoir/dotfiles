bindkey -e

fpath=($XDG_CONFIG_HOME/zsh/functions/*(N-/) $fpath)

# 補完
autoload -U compinit
compinit
setopt auto_list
setopt auto_menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

PROMPT='%F{074}[%n@%m]%f# '
RPROMPT='%F{048}[%~]%f'

# ビープ音を消す
setopt no_beep

setopt auto_cd
function chpwd() { ls --color=always }

# コマンド履歴関連
setopt hist_ignore_dups
setopt share_history
SAVEHIST=100
HISTFILE=$HOME/.zsh_history

alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ../'
alias ...='cd ../../'
alias vi='\vim'
alias vim='VIM=$NVIM nvim'

# vim_version=`vim --version | head -1 | sed 's/^.*\ \([0-9]\)\.\([0-9]\)\ .*$/\1\2/'`
alias less=$VIM'/macros/less.sh'

# coloring directory in ls
if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=egfxcxdxbxegedabagacad
    alias ls='ls -G'
    alias ll='ls -laG'
else
    [ -f $HOME/.colorrc ] && eval `dircolors $HOME/.colorrc`
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
fi

# tmux
if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
            # デタッチ済みセッションが存在する
            exec tmux attach && echo "tmux attached session "
        else
            exec tmux new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi

# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zaw"
zplug "peco/peco", as:command, from:gh-r, use:'*amd64*'

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook is-at-least
if is-at-least 4.3.10; then
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':filter-select' case-insensitive yes
    bindkey '^@' zaw-cdr
fi

if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# 自作関数の読み込み
autoload -Uz precmd tinify

# ローカルファイルの読み込み
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
