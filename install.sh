#!/bin/sh
mkdir -p ~/.vim
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/vim/userautoload ~/.vim

export XDG_CONFIG_HOME=~/.config
mkdir -p $XDG_CONFIG_HOME
ln -sf ~/dotfiles/nvim $XDG_CONFIG_HOME

ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zprofile ~/.zprofile

ln -sf ~/dotfiles/npmrc ~/.npmrc

ln -sf ~/dotfiles/inputrc ~/.inputrc

if type git >/dev/null 2>&1; then
    git config --global alias.s status
    git config --global alias.d diff
fi
