#!/bin/sh
# Thanks, @kaorimatz!

# curl -sL dot.pandanoir.net | sh

set -eu

XDG_CONFIG_HOME=$HOME/.config
ZDOTDIR=$XDG_CONFIG_HOME/zsh
dotfiles=$HOME/dotfiles
has() {
    type "$1" > /dev/null 2>&1
}
setup() {
    if [ ! -d "$dotfiles" ]; then
        git clone https://github.com/pandanoir/dotfiles "$dotfiles"
        git clone https://github.com/arcticicestudio/nord-gnome-terminal "$dotfiles/nord-gnome-terminal"
    fi
    deploy
    init
}

deploy() {
    symlink() {
        [ -e $2 ] || ln -sf $1 $2
    }
    dotlink() {
        symlink $dotfiles/$1 $HOME/.$1
    }
    mkdir -p $XDG_CONFIG_HOME/{tmux,vim,npm,readline,zsh/functions,fish/functions}
    mkdir -p $XDG_CACHE_HOME/{vim,npm}
    mkdir -p $XDG_DATA_HOME/{npm,rustup,zsh}

    symlink $dotfiles/vimrc $XDG_CONFIG_HOME/vim/vimrc
    dotlink "spacemacs"
    {
        cd $XDG_CACHE_HOME/vim
        ls -1 $dotfiles/vim | xargs -I{} ln -sf $dotfiles/vim/{} $XDG_CONFIG_HOME/vim
    }


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

    symlink $dotfiles/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
    symlink $dotfiles/zshrc $ZDOTDIR/.zshrc
    symlink $dotfiles/zprofile $ZDOTDIR/.zprofile
    dotlink zshenv
    symlink $dotfiles/zprofile $HOME/.bash_profile
    symlink $dotfiles/npmrc $XDG_CONFIG_HOME/npm/npmrc
    symlink $dotfiles/inputrc $XDG_CONFIG_HOME/readline/inputrc
    bash $dotfiles/nord-gnome-terminal/src/nord.sh
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
    if [ ! -f  $ZDOTDIR/.zshrc.local ]; then
        echo 'export NVIM=/usr/share/nvim' > $ZDOTDIR/.zshrc.local
    fi
    if has git && [ ! -d "$HOME/.emacs.d" ]; then
        git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
    fi
}
if [ $# -eq 0 ]; then
    setup
elif [ "$1" = "deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "-i" ]; then
    init
fi
