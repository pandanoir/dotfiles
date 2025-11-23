source "$DOTDIR/scripts/utils.sh"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macOS" ;;
    *) echo "other" ;;
  esac
}

install_mac() {
  if ! command_exists brew; then
    info "install Homebrew"
    NONINTERACTIVE=1 \
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    info "install packages from Brewfile"
    brew bundle --file "$DOTDIR/Brewfile"
  fi

  if ! dir_exists "$XDG_CACHE_HOME/fzf"; then
    info "install fzf"
    git clone https://github.com/junegunn/fzf "$XDG_CACHE_HOME/fzf"
    bash "$XDG_CACHE_HOME/fzf/install" --xdg --no-key-bindings --completion --no-update-rc --no-bash
  elif is_update_mode; then
    info "update fzf"
    cd "$XDG_CACHE_HOME/fzf"
    git pull
    bash "$XDG_CACHE_HOME/fzf/install" --xdg --no-key-bindings --completion --no-update-rc --no-bash
    cd -
  fi
}

install_tools() {
  OS=$(detect_os)
  if [[ "$OS" == "macOS" ]]; then
    install_mac
  fi
}
