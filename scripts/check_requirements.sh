source "$DOTDIR/scripts/utils.sh"

check_requirements() {
  info "check requirements..."

  local is_every_requirement_met=true
  if ! command_exists nvim && ! file_exists "$HOME/local/nvim/bin/nvim"; then
    warn "you must install neovim! please see installing-neovim : https://github.com/neovim/neovim/wiki/Installing-Neovim"
    is_every_requirement_met=false
  fi

  if ! dir_exists "$XDG_CACHE_HOME/fzf"; then
    info "install fzf"
    git clone https://github.com/junegunn/fzf "$XDG_CACHE_HOME/fzf"
    bash "$XDG_CACHE_HOME/fzf/install" --xdg --no-key-bindings --completion --no-update-rc --no-bash
  elif is_update_mode; then
    info "update fzf"
    cd "$XDG_CACHE_HOME/fzf"
    git pull
    cd -
  fi

  if ! command_exists zsh; then
    warn "zsh isn't installed"
    is_every_requirement_met=false
  else
    if ! dir_exists "$XDG_CACHE_HOME/zinit"; then
      info "install zinit"
      git clone https://github.com/zdharma-continuum/zinit.git "$XDG_CACHE_HOME/zinit/bin"
    elif is_update_mode; then
      info "update zinit"
      cd "$XDG_CACHE_HOME/zinit/bin"
      git pull
      cd -
    fi
  fi

  if ! command_exists tmux; then
    warn "tmux isn't installed"
    is_every_requirement_met=false
  else
    if ! dir_exists "$XDG_CONFIG_HOME/tmux/plugins/tpm"; then
      info "install tpm"
      git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"
    elif is_update_mode; then
      info "update tpm"
      cd "$XDG_CONFIG_HOME/tmux/plugins/tpm"
      git pull
      cd -
    fi
  fi

  if $is_every_requirement_met; then
    info "required tools are installed."
  else
    warn "required tools are not installed"
  fi
}
