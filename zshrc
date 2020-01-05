# utility func
file_exists() {
    [ -f $1 ]
}
command_exists() { type "$1" > /dev/null 2>&1; }

# emacsのtrampがタイムアウトするのに対応
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

bindkey -e

# 自作関数の読み込み
autoload -Uz tinify estart

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

prompt-set(){
    PROMPT="%F{074}[%n@%m]%f# "
    RPROMPT='%F{048}[%~]%f'
}
prompt-reset() {
    PROMPT="# "
    RPROMPT=''
}
prompt-set

setopt no_beep # ビープ音を消す
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ

setopt auto_cd
function chpwd() { ls --color=always }

# コマンド履歴関連
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
SAVEHIST=100
HISTFILE=$HOME/.zsh_history


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
        zplug install
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

source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/keybind.zsh"

# 挙動:
# 1. 何もセッションが存在しない -> new-session
# 1. SSH先にすでにattachしたセッションが存在する -> detach済みセッションがあればattach、なければnew-session
# 1. ローカルで新しく端末を立ち上げる(=すでにattachしたセッションが存在する) -> tmuxを起動したくない
# -> ローカルとSSH先を区別する必要がある
if [ `whoami` != 'root' -a -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session; then
            if [[ -n `tmux list-sessions | grep '(attached)'` ]]; then
                # アタッチ済み
                if [ ! -v NOT_NEW_SESSION_TMUX ]; then
                    if [[ -n `tmux list-sessions | grep -v '(attached)'` ]]; then
                        # デタッチ済みセッションがある
                        exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf attach && echo "tmux attached session"
                    else
                        exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session && echo "tmux created new session"
                    fi
                fi
            else
                exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf attach && echo "tmux attached session"
            fi
        else
            exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi
