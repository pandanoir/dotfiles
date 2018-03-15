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
        [ -e "$2" ] || ln -sf "$1" "$2"
    }
    dotlink() {
        symlink "$dotfiles/$1" "$HOME/.$1"
    }
    dotlink "vimrc"
    dotlink "vim"

    mkdir -p $XDG_CONFIG_HOME
    mkdir -p $XDG_CONFIG_HOME/fish/functions
    mkdir -p $XDG_CONFIG_HOME/zsh/functions

    symlink "$dotfiles/nvim" $XDG_CONFIG_HOME
    symlink $dotfiles/fish/config.fish $XDG_CONFIG_HOME/fish/config.fish
    symlink $dotfiles/fish/fishfile $XDG_CONFIG_HOME/fish/fishfile
    {
        cd $XDG_CONFIG_HOME/fish/functions
        ls -1 $dotfiles/fish/functions | xargs -I{} ln -sf $dotfiles/fish/functions/{} $XDG_CONFIG_HOME/fish/functions
    }
    {
        cd $XDG_CONFIG_HOME/zsh/functions
        ls -1 $dotfiles/zsh/functions | xargs -I{} ln -sf $dotfiles/zsh/functions/{} $XDG_CONFIG_HOME/zsh/functions
    }

    dotlink "tmux.conf"
    dotlink "zshrc"
    dotlink "zprofile"
    symlink $dotfiles/zprofile $HOME/.bash_profile
    dotlink "npmrc"
    dotlink "inputrc"
}
init() {
    if has git; then
        git config --global alias.s status
        git config --global alias.d diff
        git config --global alias.unstage "reset HEAD"
    fi

    if has zsh && [ ! -d "$HOME/.zplug" ]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
    fi

    if has fish && [ ! -f "$XDG_CONFIG_HOME/fish/functions/fisher.fish" ]; then
        curl -Lo $XDG_CONFIG_HOME/fish/functions/fisher.fish --create-dirs https://git.io/fisher
    fi

    if has git && has tmux && [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    fi

    if [ ! -f  $XDG_CONFIG_HOME/fish/config.local.fish ]; then
        {
            echo 'set -x NODEBREW_ROOT $HOME/.nodebrew'
            echo 'set NVIM /usr/share/nvim'
            echo 'set -x NVIM $NVIM'
        } > $XDG_CONFIG_HOME/fish/config.local.fish
    fi
    if [ ! -f  $HOME/.zshrc.local ]; then
        echo 'export NVIM=/usr/share/nvim' > $HOME/.zshrc.local
    fi
}
if [ $# -eq 0 ]; then
    setup
elif [ "$1" = "deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
    init
fi
