notify "setup ruby..."
RBENV_ROOT="$HOME/.rbenv"
if dir_exists $RBENV_ROOT; then
  export RBENV_ROOT
  add_to_path_if_not_exists "$RBENV_ROOT/shims"
  eval "$(rbenv init -)"
fi
