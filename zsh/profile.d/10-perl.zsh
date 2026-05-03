if command_exists plenv; then
  export PLENV_ROOT="$HOME/.plenv"
  add_to_path_if_not_exists "${PLENV_ROOT}/shims"
  eval "$(plenv init -)"
fi
