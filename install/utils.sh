has() { type "$1" > /dev/null 2>&1; }
file_exists() { [ -f $1 ]; }
dir_exists() { [ -d $1 ]; }

info() { echo -e "\033[0;34m[INFO]\033[0;39m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0;39m $1"; }

symlink() {
  # すでにシンボリックリンクが存在する場合は作成しない
  if [ -e "$2" ]; then
    return
  fi
  info "create symlink from $DOTDIR/$1 to $2"
  ln -sf "$DOTDIR/$1" "$2"
}

