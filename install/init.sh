source "$DOTDIR/install/utils.sh"

init() {
  info "start init"
  git config --global alias.s status
  git config --global alias.d diff
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.b branch
  git config --global alias.unstage "reset HEAD"
  git config --global alias.un "reset HEAD"
  git config --global rebase.autostash true

  if ! file_exists "$ZDOTDIR/.zshrc.local"; then
    echo 'export NVIM=/usr/share/nvim' > "$ZDOTDIR/.zshrc.local"
  fi
  info "finish init"
}

