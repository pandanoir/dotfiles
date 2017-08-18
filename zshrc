export LANG=ja_JP.UTF-8
export PATH=/usr/local/bin:$PATH

# 補完
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

PROMPT='[%n@%m]# '
RPROMPT='[%d]'

# ビープ音を消す
setopt no_beep

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ../'
alias ...='cd ../../'
alias vi='\vim'
alias vim='VIM=/usr/local/Cellar/neovim/0.2.0_1/share/nvim nvim'

# vim_version=`vim --version | head -1 | sed 's/^.*\ \([0-9]\)\.\([0-9]\)\ .*$/\1\2/'`
alias less=$VIM'/macros/less.sh'

# coloring directory in ls
if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=egfxcxdxbxegedabagacad
    alias ls='ls -G'
    alias ll='ls -laG'
else
    eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
fi

if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
            # デタッチ済みセッションが存在する
            tmux attach && echo "tmux attached session "
        else
            tmux new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi
