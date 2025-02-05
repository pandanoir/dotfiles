autoload -U compinit
if compinit -C; then
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*:default' menu select=1
  zstyle ':completion:*' menu select
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/cache
  setopt auto_list
  setopt IGNOREEOF
  setopt auto_menu
  _ssh() {
    compadd $(grep '^Host ' ~/.ssh/config | awk '$0=$2' | sort)
  }
  compdef _ssh ssh
fi
# setopt menu_complete
