source "$ZDOTDIR/utils.zsh"

source_notify "$ZDOTDIR/launch_multiplexer.zsh"

source_notify "$ZDOTDIR/set_options.zsh"
source_notify "$ZDOTDIR/alias.zsh"
source_notify "$ZDOTDIR/keybind.zsh"
source_notify "$ZDOTDIR/init_completion.zsh"
source_notify_if_exists "$XDG_CACHE_HOME/fzf/shell/completion.zsh"
source_notify_if_exists "$XDG_CACHE_HOME/fzf/shell/key-bindings.zsh"
source_notify "$ZDOTDIR/zinit.zsh"

source_notify_if_exists "$ZDOTDIR/.zshrc.local"

if command_exists starship; then
  eval "$(starship init zsh)"
fi

if (which zprof >/dev/null 2>&1); then
  zprof
fi

notify "loaded zshrc"; echo
