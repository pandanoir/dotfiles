#!/bin/sh
# Thanks, @kaorimatz!
set -eu

has() {
    type "$1" > /dev/null 2>&1
}
setup() {
    dotfiles=$HOME/dotfiles


    if [ ! -d "$dotfiles" ]; then
        git clone https://github.com/pandanoir/dotfiles "$dotfiles"
    fi
    deploy
    init
}

deploy() {
    dotfiles=$HOME/dotfiles
    symlink() {
        [ -e ".$1" ] || ln -sf "$dotfiles/$1" "$HOME/.$1"
    }
    mkdir -p $HOME/.vim
    symlink "vimrc"
    ln -sf $dotfiles/vim/userautoload $HOME/.vim

    export XDG_CONFIG_HOME=$HOME/.config
    mkdir -p $XDG_CONFIG_HOME
    mkdir -p $XDG_CONFIG_HOME/fish
    ln -sf "$dotfiles/nvim" $XDG_CONFIG_HOME
    ln -s $dotfiles/config.fish $XDG_CONFIG_HOME/fish/config.fish

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
    if has zsh && [ ! -d "$HOME/.zplug" ]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
    fi
}
if [ $# -eq 0 ]; then
    setup
elif [ "$1" = "deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
    init
fi
