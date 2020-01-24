# zplug
source $ZPLUG_HOME/init.zsh


zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "mollifier/cd-bookmark"
zplug "mollifier/zload"
zplug "momo-lab/zsh-replace-multiple-dots"
zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh

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
