#!/bin/sh
# Thanks, @kaorimatz!
set -eu

XDG_CONFIG_HOME=$HOME/.config
dotfiles=$HOME/dotfiles
has() {
    type "$1" > /dev/null 2>&1
}
setup() {
    if [ ! -d "$dotfiles" ]; then
        git clone https://github.com/pandanoir/dotfiles "$dotfiles"
    fi
    deploy
    init
}

deploy() {
    symlink() {
        [ -e ".$1" ] || ln -sf "$dotfiles/$1" "$HOME/.$1"
    }
    mkdir -p $HOME/.vim
    symlink "vimrc"
    ln -sf $dotfiles/vim/userautoload $HOME/.vim

    export XDG_CONFIG_HOME=$XDG_CONFIG_HOME
    mkdir -p $XDG_CONFIG_HOME
    mkdir -p $XDG_CONFIG_HOME/fish
    ln -sf "$dotfiles/nvim" $XDG_CONFIG_HOME
    ln -sf $dotfiles/config.fish $XDG_CONFIG_HOME/fish/config.fish
    ln -sf $dotfiles/fishfile $XDG_CONFIG_HOME/fish/fishfile

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
    if has fish; then
        curl -Lo $XDG_CONFIG_HOME/fish/functions/fisher.fish --create-dirs https://git.io/fisher
    fi
    if has git && has tmux;
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    {
        echo 'set -x NODEBREW_ROOT ~/.nodebrew'
        echo 'set NVIM /usr/share/nvim'
        echo 'set -x NVIM $NVIM'
    } > ~/.config/fish/config.local.fish
    echo 'export NVIM=/usr/share/nvim' > ~/.zshrc.local
}
if [ $# -eq 0 ]; then
    setup
elif [ "$1" = "deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
    init
fi
