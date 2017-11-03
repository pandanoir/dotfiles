#!/bin/sh
deploy() {
    echo "deploy"
    mkdir -p ~/.vim
    ln -sf ~/dotfiles/vimrc ~/.vimrc
    ln -sf ~/dotfiles/vim/userautoload ~/.vim

    export XDG_CONFIG_HOME=~/.config
    mkdir -p $XDG_CONFIG_HOME
    ln -sf ~/dotfiles/nvim $XDG_CONFIG_HOME
    ln -sf ~/dotfiles/config.fish $XDG_CONFIG_HOME/fish/config.fish

    ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

    ln -sf ~/dotfiles/zshrc ~/.zshrc
    ln -sf ~/dotfiles/zprofile ~/.zprofile

    ln -sf ~/dotfiles/npmrc ~/.npmrc

    ln -sf ~/dotfiles/inputrc ~/.inputrc
}
init() {
    echo "init"
    if type git >/dev/null 2>&1; then
        git config --global alias.s status
        git config --global alias.d diff
    fi
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
}
if [ "$1" = "deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
    init
fi
