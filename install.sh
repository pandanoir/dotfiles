#!/bin/bash
# Thanks, @kaorimatz!

# curl -sL dot.pandanoir.net | sh

set -eu

[ ! -v XDG_CONFIG_HOME ] && XDG_CONFIG_HOME="$HOME/.config"
[ ! -v XDG_CACHE_HOME ] && XDG_CACHE_HOME="$HOME/.cache"
[ ! -v XDG_DATA_HOME ] && XDG_DATA_HOME="$HOME/.local/share"
[ ! -v ZDOTDIR ] && ZDOTDIR="$XDG_CONFIG_HOME/zsh"

dotfiles="$HOME/dotfiles"
has() { type "$1" > /dev/null 2>&1; }
file_exists() { [ -f $1 ]; }
dir_exists() { [ -d $1 ]; }

setup() {
  if ! dir_exists "$dotfiles"; then
    git clone https://github.com/pandanoir/dotfiles "$dotfiles"
  fi
  deploy
  init
}
info() {
  echo -e "\033[0;34m[INFO]\033[0;39m $1"
}

deploy() {
  info "start deploy"
  symlink() {
    if ! [ -e "$2" ]; then
      info "create symlink from $dotfiles/$1 to $2"
      ln -sf "$dotfiles/$1" "$2"
    fi
  }
  dir_symlink() {
    for file in `ls -1 "$1"`; do
      if ! [ -e "$2/$file" ]; then
        info "create symlink from $1/$file to $2/$file"
        ln -sf "$1/$file" "$2"
      fi
    done
  }
  mkdir -p "$XDG_CONFIG_HOME/"{tmux,vim,npm,readline,zsh/functions} \
    "$XDG_CACHE_HOME/"{vim,npm} \
    "$XDG_DATA_HOME/"{npm,rustup,zsh}

  symlink nvim  "$XDG_CONFIG_HOME/nvim"
  symlink vimrc "$XDG_CONFIG_HOME/vim/vimrc"
  dir_symlink   "$dotfiles/vim" "$XDG_CONFIG_HOME/vim"

  dir_symlink "$dotfiles/zsh/functions" "$ZDOTDIR/functions"
  for file in `ls -1 "$dotfiles/zsh/" | grep \.zsh$`; do
    symlink zsh/"$file" "$ZDOTDIR/$file"
  done
  symlink zsh/zshrc    "$ZDOTDIR/.zshrc"
  symlink zsh/zprofile "$ZDOTDIR/.zprofile"
  symlink zshenv       "$HOME/.zshenv"
  symlink zprofile     "$HOME/.bash_profile"

  symlink tmux.conf "$XDG_CONFIG_HOME/tmux/tmux.conf"
  symlink npmrc     "$XDG_CONFIG_HOME/npm/npmrc"
  symlink inputrc   "$XDG_CONFIG_HOME/readline/inputrc"
  symlink ranger    "$XDG_CONFIG_HOME/ranger"

  if has ranger && ! dir_exists "$dotfiles/ranger/plugins/ranger_devicons"; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons "$dotfiles/ranger/plugins/ranger_devicons"
    cd "$dotfiles/ranger/plugins/ranger_devicons"
    make install
  fi
  info "finish deploy"
}
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

  if ! dir_exists "$XDG_CONFIG_HOME/tmux/plugins/tpm"; then
    git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"
  fi
  if ! file_exists "$ZDOTDIR/.zshrc.local"; then
    echo 'export NVIM=/usr/share/nvim' > "$ZDOTDIR/.zshrc.local"
  fi
  info "finish init"
}

# check the requirements
if ! has git; then
  echo "you must install git!"
  exit 1
fi
if ! has zsh; then
  echo "you must install zsh!"
  exit 1
fi
if ! has nvim && ! file_exists "$HOME/local/nvim/bin/nvim"; then
  echo "you must install neovim! please see installing-neovim : https://github.com/neovim/neovim/wiki/Installing-Neovim"
  exit 1
fi
if ! has tmux; then
  echo "you must install tmux!"
  exit 1
fi

if ! dir_exists "$XDG_CACHE_HOME/zplug"; then
  info "install zplug"
  git clone https://github.com/zplug/zplug "$XDG_CACHE_HOME/zplug"
  zsh "$XDG_CACHE_HOME/zplug/init.zsh"
fi
if ! dir_exists "$XDG_CACHE_HOME/zinit"; then
  info "install zinit"
  git clone https://github.com/zdharma-continuum/zinit.git "$XDG_CACHE_HOME/zinit/bin"
fi
if ! dir_exists "$XDG_CACHE_HOME/fzf"; then
  info "install fzf"
  git clone https://github.com/junegunn/fzf "$XDG_CACHE_HOME/fzf"
  bash "$XDG_CACHE_HOME/fzf/install" --xdg --no-key-bindings --completion --no-update-rc --no-bash
fi

if [ $# -eq 0 ]; then
  setup
elif [ "$1" = "deploy" -o "$1" = "-d" ]; then
  deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
  init
fi
