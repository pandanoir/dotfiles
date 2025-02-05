symlink() {
  # すでにシンボリックリンクが存在する場合は作成しない
  if [ -e "$2" ]; then
    return
  fi

  info "create symlink from $DOTDIR/$1 to $2"
  if ! [ -d `dirname $2` ]; then
    mkdir -p `dirname $2`
  fi
  ln -sf "$DOTDIR/$1" "$2"
}

deploy() {
  info "start deploy"

  # vim/neovim
  mkdir -p "$XDG_CACHE_HOME/vim"
  symlink nvim "$XDG_CONFIG_HOME/nvim"
  symlink nvim "$XDG_CONFIG_HOME/nvim-sub"
  symlink vim/raw_vimrc "$HOME/.vimrc"
  for file in `ls -1 "$DOTDIR/vim" | grep -v 'raw_vimrc'`; do
    symlink "vim/$file" "$XDG_CONFIG_HOME/vim/$file"
  done

  # zsh
  for file in `ls -1 "$DOTDIR/zsh/" | grep '.zsh$' | grep -v 'zshrc' | grep -v 'zprofile'`; do
    symlink "zsh/$file" "$ZDOTDIR/$file"
  done
  symlink zsh/zshrc.zsh "$ZDOTDIR/.zshrc"
  symlink zsh/zprofile.zsh "$ZDOTDIR/.zprofile"
  symlink zsh/zshenv "$HOME/.zshenv"

  # zellij
  symlink zellij "$XDG_CONFIG_HOME/zellij"

  # other
  symlink tmux.conf "$XDG_CONFIG_HOME/tmux/tmux.conf"
  mkdir -p {$XDG_CACHE_HOME,$XDG_DATA_HOME}"/npm"
  symlink npmrc     "$XDG_CONFIG_HOME/npm/npmrc"
  symlink inputrc   "$XDG_CONFIG_HOME/readline/inputrc"
  symlink ranger    "$XDG_CONFIG_HOME/ranger"
  symlink wezterm.lua "$XDG_CONFIG_HOME/wezterm/wezterm.lua"
  symlink starship.toml "$XDG_CONFIG_HOME/starship.toml"
  mkdir -p "$XDG_DATA_HOME/rustup"

  if has ranger && ! dir_exists "$DOTDIR/ranger/plugins/ranger_devicons"; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons "$DOTDIR/ranger/plugins/ranger_devicons"
    cd "$DOTDIR/ranger/plugins/ranger_devicons"
    make install
  fi
  info "finish deploy"
}

