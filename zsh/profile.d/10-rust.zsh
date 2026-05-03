notify "setup rust..."
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

if dir_exists $HOME/.cargo; then
  add_to_path_if_not_exists "$HOME/.cargo/bin"
  source "$HOME/.cargo/env"
  . "$HOME/.cargo/env"
fi
if dir_exists $XDG_DATA_HOME/cargo; then
  CARGO_HOME="$XDG_DATA_HOME"/cargo
  export CARGO_HOME=$CARGO_HOME
  add_to_path_if_not_exists "$CARGO_HOME/bin"
fi
