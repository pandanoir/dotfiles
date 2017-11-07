#!/bin/sh
# Thanks, @kaorimatz!
set -eu

has() {
    type "$1" > /dev/null 2>&1
}
deploy() {
    dotfiles=$HOME/dotfiles
    symlink() {
        [ -e ".$1" ] || ln -sf "$dotfiles/$1" "$HOME/.$1"
    }
    mkdir -p ~/.vim
    symlink "vimrc"
    ln -sf ~/dotfiles/vim/userautoload ~/.vim

    export XDG_CONFIG_HOME=~/.config
    mkdir -p $XDG_CONFIG_HOME
    ln -sf "$dotfiles/nvim" $XDG_CONFIG_HOME
    ln -sf "$dotfiles/config.fish" $XDG_CONFIG_HOME/fish/config.fish

    symlink "tmux.conf"
    symlink "zshrc"
    symlink "zprofile"
    symlink "npmrc"
    symlink "inputrc"
}
init() {
    if has git; then
        git config --global alias.s status
        git config --global alias.d diff
    fi
    if [ ! -d "$HOME/.zplug" ]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
    fi
}
if [ "$1" = "deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
    init
fi
