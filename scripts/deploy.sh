source "$DOTDIR/scripts/utils.sh"

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

# テンプレートとして初回のみコピー (既に存在すればスキップ)
copy_template() {
  if [ -e "$2" ]; then
    return
  fi

  info "copy template from $DOTDIR/$1 to $2"
  if ! [ -d `dirname $2` ]; then
    mkdir -p `dirname $2`
  fi
  cp "$DOTDIR/$1" "$2"
}

deploy() {
  info "start to deploy"

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
  symlink tmux/tmux.conf "$XDG_CONFIG_HOME/tmux/tmux.conf"
  mkdir -p {$XDG_CACHE_HOME,$XDG_DATA_HOME}"/npm"
  symlink npmrc     "$XDG_CONFIG_HOME/npm/npmrc"
  symlink inputrc   "$XDG_CONFIG_HOME/readline/inputrc"
  symlink ranger    "$XDG_CONFIG_HOME/ranger"
  symlink wezterm.lua "$XDG_CONFIG_HOME/wezterm/wezterm.lua"
  symlink starship.toml "$XDG_CONFIG_HOME/starship.toml"
  mkdir -p "$XDG_DATA_HOME/rustup"

  # claude code
  copy_template claude/settings.json "$HOME/.claude/settings.json"
  symlink claude/hooks/validate-bash.sh "$HOME/.claude/hooks/validate-bash.sh"
  symlink claude/agents/reviewer.md "$HOME/.claude/agents/reviewer.md"
  symlink claude/statusline-command.sh "$HOME/.claude/statusline-command.sh"

  # cage
  symlink cage/presets.yml "$XDG_CONFIG_HOME/cage/presets.yml"

  if command_exists ranger && ! dir_exists "$DOTDIR/ranger/plugins/ranger_devicons"; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons "$DOTDIR/ranger/plugins/ranger_devicons"
    cd "$DOTDIR/ranger/plugins/ranger_devicons"
    make install
  fi
  info "finish deploying"
}

