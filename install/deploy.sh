source "$DOTDIR/install/utils.sh"

deploy() {
  info "start deploy"
  mkdir -p "$XDG_CONFIG_HOME/"{tmux,vim,npm,readline,zsh/functions} \
    "$XDG_CACHE_HOME/"{vim,npm} \
    "$XDG_DATA_HOME/"{npm,rustup,zsh}

  # vim/neovim
  symlink nvim  "$XDG_CONFIG_HOME/nvim"
  symlink vimrc "$XDG_CONFIG_HOME/vim/vimrc"
  dir_symlink   "$DOTDIR/vim" "$XDG_CONFIG_HOME/vim"

  # zsh
  dir_symlink "$DOTDIR/zsh/functions" "$ZDOTDIR/functions"
  for file in `ls -1 "$DOTDIR/zsh/" | grep \.zsh$`; do
    symlink zsh/"$file" "$ZDOTDIR/$file"
  done
  symlink zsh/zshrc    "$ZDOTDIR/.zshrc"
  symlink zsh/zprofile "$ZDOTDIR/.zprofile"
  symlink zshenv       "$HOME/.zshenv"
  symlink zprofile     "$HOME/.bash_profile"

  # other
  symlink tmux.conf "$XDG_CONFIG_HOME/tmux/tmux.conf"
  symlink npmrc     "$XDG_CONFIG_HOME/npm/npmrc"
  symlink inputrc   "$XDG_CONFIG_HOME/readline/inputrc"
  symlink ranger    "$XDG_CONFIG_HOME/ranger"

  if has ranger && ! dir_exists "$DOTDIR/ranger/plugins/ranger_devicons"; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons "$DOTDIR/ranger/plugins/ranger_devicons"
    cd "$DOTDIR/ranger/plugins/ranger_devicons"
    make install
  fi
  info "finish deploy"
}
