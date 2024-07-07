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

  if ! dir_exists "$XDG_DATA_HOME/nvim/lazy-rocks"; then
    echo "you should exec hererocks '$XDG_DATA_HOME/nvim/lazy-rocks/hererocks' -l5.1 -rlatest"
  fi

  info "finish init"
}

