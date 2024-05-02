symlink() {
  # すでにシンボリックリンクが存在する場合は作成しない
  if [ -e "$2" ]; then
    return
  fi
  info "create symlink from $DOTDIR/$1 to $2"
  ln -sf "$DOTDIR/$1" "$2"
}

deploy() {
  info "start deploy"

  # vim/neovim
  mkdir -p "$XDG_CONFIG_HOME/vim" "$XDG_CACHE_HOME/vim"
  symlink nvim  "$XDG_CONFIG_HOME/nvim"
  symlink vim/raw_vimrc "$HOME/.vimrc"
  for file in `ls -1 "$DOTDIR/vim" | grep -v 'raw_vimrc'`; do
    symlink "vim/$file" "$XDG_CONFIG_HOME/vim/$file"
  done

  # zsh
  mkdir -p "$XDG_CONFIG_HOME/zsh/functions" "$XDG_DATA_HOME/zsh"

  for file in `ls -1 "$DOTDIR/zsh/" | grep '.zsh$'`; do
    symlink "zsh/$file" "$ZDOTDIR/$file"
  done
  for file in `ls -1 "$DOTDIR/zsh/functions"`; do
    symlink "zsh/functions/$file" "$ZDOTDIR/functions/$file"
  done
  symlink zsh/zshrc    "$ZDOTDIR/.zshrc"
  symlink zsh/zprofile "$ZDOTDIR/.zprofile"
  symlink zsh/zshenv       "$HOME/.zshenv"
  symlink zsh/zprofile     "$HOME/.bash_profile"

  # other
  mkdir -p "$XDG_CONFIG_HOME/"{tmux,npm,readline} \
    "$XDG_CACHE_HOME/npm" \
    "$XDG_DATA_HOME/"{npm,rustup}
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

