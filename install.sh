#!/bin/bash
# Thanks, @kaorimatz!

# curl -sL dot.pandanoir.net | sh

set -eu

DOTDIR="$HOME/dotfiles"
[ ! -v XDG_CONFIG_HOME ] && XDG_CONFIG_HOME="$HOME/.config"
[ ! -v XDG_CACHE_HOME ] && XDG_CACHE_HOME="$HOME/.cache"
[ ! -v XDG_DATA_HOME ] && XDG_DATA_HOME="$HOME/.local/share"
[ ! -v ZDOTDIR ] && ZDOTDIR="$XDG_CONFIG_HOME/zsh"

source "$DOTDIR/install/deploy.sh"
source "$DOTDIR/install/init.sh"

if ! dir_exists "$DOTDIR"; then
  git clone https://github.com/pandanoir/dotfiles "$DOTDIR"
fi

# check the requirements
if ! has git; then
  warn "you must install git!"
  exit 1
fi

if ! has nvim && ! file_exists "$HOME/local/nvim/bin/nvim"; then
  warn "you must install neovim! please see installing-neovim : https://github.com/neovim/neovim/wiki/Installing-Neovim"
fi

if ! dir_exists "$XDG_CACHE_HOME/fzf"; then
  info "install fzf"
  git clone https://github.com/junegunn/fzf "$XDG_CACHE_HOME/fzf"
  bash "$XDG_CACHE_HOME/fzf/install" --xdg --no-key-bindings --completion --no-update-rc --no-bash
fi

if ! has zsh; then
  warn "zsh isn't installed"
elif ! dir_exists "$XDG_CACHE_HOME/zinit"; then
  info "install zinit"
  git clone https://github.com/zdharma-continuum/zinit.git "$XDG_CACHE_HOME/zinit/bin"
fi

if ! has tmux; then
  warn "tmux isn't installed"
elif ! dir_exists "$XDG_CONFIG_HOME/tmux/plugins/tpm"; then
  git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"
fi

info "requirements are met"

if [ $# -eq 0 ]; then
  deploy
  init
elif [ "$1" = "deploy" ] || [ "$1" = "-d" ]; then
  deploy
elif [ "$1" = "init" ] || [ "$1" = "-i" ]; then
  init
fi
