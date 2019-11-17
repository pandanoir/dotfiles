# utility func
file_exists() {
    [ -f $1 ]
}
command_exists() { type "$1" > /dev/null 2>&1; }

# emacsのtrampがタイムアウトするのに対応
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

bindkey -e

# 自作関数の読み込み
autoload -Uz precmd tinify estart

# 補完
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/cache
setopt auto_list
setopt IGNOREEOF
setopt auto_menu
setopt menu_complete

PROMPT='%F{074}[%n@%m]%f$ '
RPROMPT='%F{048}[%~]%f'

setopt no_beep # ビープ音を消す
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ


setopt auto_cd
function chpwd() { ls --color=always }

# コマンド履歴関連
setopt hist_ignore_dups
setopt share_history
SAVEHIST=100
HISTFILE=$HOME/.zsh_history

alias mv='mv -i'
alias cp='cp -i'
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
alias -g .zshrc="$ZDOTDIR/.zshrc"
alias -g .zsh="$ZDOTDIR/.zshrc"
alias -g .zprofile="$ZDOTDIR/.zprofile"
alias -g .zp="$ZDOTDIR/.zprofile"
alias -g .zpr="$ZDOTDIR/.zprofile"
alias -g .zpro="$ZDOTDIR/.zprofile"

expand-alias() {
    zle _expand_alias
    zle expand-word
}

zle -N expand-alias

bindkey ' '   magic-space
bindkey '^ '    expand-alias

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
if command_exists nvim; then
    alias vi="env -u VIM env VIMINIT=':source $XDG_CONFIG_HOME'/vim/vimrc vi"
    alias vim="nvim"
fi
if command_exists exa; then
    alias ls="exa"
    alias ll='exa -algh --git'
    function chpwd() { exa }
fi
if command_exists bat; then alias cat='bat'; fi


# zplug
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zaw"
zplug "mollifier/cd-bookmark"
zplug "mollifier/zload"
zplug "momo-lab/zsh-replace-multiple-dots"

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook is-at-least
if is-at-least 4.3.10; then
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':filter-select' case-insensitive yes
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
if file_exists ~/.fzf.zsh; then
    source ~/.fzf.zsh;
fi
if file_exists "$ZDOTDIR/.zshrc.local"; then
    source $ZDOTDIR/.zshrc.local;
fi

if [ `whoami` != 'root' -a -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session; then
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
