source "$ZDOTDIR/utils.zsh"

source "$ZDOTDIR/launch_multiplexer.zsh"

source "$ZDOTDIR/set_options.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/keybind.zsh"
source "$ZDOTDIR/init_completion.zsh"
source_if_exists "$XDG_CACHE_HOME/fzf/shell/completion.zsh"
source_if_exists "$XDG_CACHE_HOME/fzf/shell/key-bindings.zsh"
source "$ZDOTDIR/zinit.zsh"

source_if_exists "$ZDOTDIR/.zshrc.local"

if command_exists starship; then
  eval "$(starship init zsh)"
fi

if (which zprof >/dev/null 2>&1); then
  zprof
fi
