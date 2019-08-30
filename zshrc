# emacsのtrampがタイムアウトするのに対応
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

bindkey -e

# 自作関数の読み込み
autoload -Uz precmd tinify estart

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
alias cdb='cd-bookmark'
alias ekill="emacsclient -e '(kill-emacs)'"
alias erestart="ekill && estart"
alias copy='xsel --clipboard --input'
alias cl='clear'
alias cle='clear'
alias clea='clear'
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --cached'
alias gs='git status'
alias gp='git push'
alias gc='git commit'

alias -g A='| awk'
alias -g C='| copy' # copy
alias -g G='| grep --color=auto' # 鉄板
alias -g H='| head' # 当然tailもね
alias -g L='| less -R'
alias -g S='| sort'
alias -g T='| tail' # 当然tailもね
alias -g U='| uniq'
alias -g X='| xargs'

# vim_version=`vim --version | head -1 | sed 's/^.*\ \([0-9]\)\.\([0-9]\)\ .*$/\1\2/'`
alias less=$VIM'/runtime/macros/less.sh'
alias emacs='emacs -nw'
alias e='emacsclient -nw -a "" 2>/dev/null'

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


# zplug
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zaw"
zplug "mollifier/cd-bookmark"
zplug "mollifier/zload"

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook is-at-least
if is-at-least 4.3.10; then
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':filter-select' case-insensitive yes
    bindkey '^@' zaw-cdr
fi

if [[ $ZPLUG_LOADFILE -nt $ZPLUG_CACHE_DIR/interface || ! -f $ZPLUG_CACHE_DIR/interface ]]; then
    if ! zplug check --verbose; then
        printf 'Install? [y/N]: '
        if read -q; then
            echo; zplug install
        fi
    fi
fi
zplug load

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# ローカルファイルの読み込み
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $ZDOTDIR/.zshrc.local ] && source $ZDOTDIR/.zshrc.local

# tmux
if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
            # デタッチ済みセッションが存在する
            exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf attach && echo "tmux attached session "
        else
            # exec tmux new-session \; source-file ~/.tmux/new-session && echo "tmux created new session"
            exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi


