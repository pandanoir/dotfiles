notify "setup go..."
GOPATH="$HOME/go"
if dir_exists "$GOPATH"; then
  export GOPATH
  add_to_path_if_not_exists "$GOPATH/bin"
fi
