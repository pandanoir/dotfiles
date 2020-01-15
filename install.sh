#!/bin/bash
# Thanks, @kaorimatz!

# curl -sL dot.pandanoir.net | sh

set -eu

if [ ! -v XDG_CONFIG_HOME ]; then XDG_CONFIG_HOME="$HOME/.config"; fi
if [ ! -v XDG_CACHE_HOME ]; then XDG_CACHE_HOME="$HOME/.cache"; fi
if [ ! -v XDG_DATA_HOME ]; then XDG_DATA_HOME="$HOME/.local/share"; fi
if [ ! -v ZDOTDIR ]; then ZDOTDIR="$XDG_CONFIG_HOME/zsh"; fi

dotfiles="$HOME/dotfiles"
has() { type "$1" > /dev/null 2>&1; }
file_exists() { [ -f $1 ]; }
dir_exists() { [ -d $1 ]; }

setup() {
    if ! dir_exists "$dotfiles"; then
        git clone https://github.com/pandanoir/dotfiles "$dotfiles"
    fi
    if ! dir_exists "$dotfiles/nord-gnome-terminal" && has "gnome-terminal"; then
        git clone https://github.com/arcticicestudio/nord-gnome-terminal "$dotfiles/nord-gnome-terminal"
    fi
    deploy
    init
}

deploy() {
    echo "[INFO] start deploy"
    symlink() {
        if ! [ -e $2 ]; then
            echo "[INFO] create symlink from $1 to $2"
            ln -sf $1 $2
        fi
    }
    dir_symlink() {
        for file in `ls -1 "$1"`; do
            if ! [ -e "$2/$file" ]; then
                echo "[INFO] create symlink from $1/$file to $2/$file"
                ln -sf "$1/$file" "$2"
            fi
        done
    }
    mkdir -p "$XDG_CONFIG_HOME/"{tmux,vim,npm,readline,zsh/functions,fish/functions}
    mkdir -p "$XDG_CACHE_HOME/"{vim,npm}
    mkdir -p "$XDG_DATA_HOME/"{npm,rustup,zsh}

    symlink "$dotfiles/vimrc" "$XDG_CONFIG_HOME/vim/vimrc"
    symlink "$dotfiles/spacemacs" "$HOME/.spacemacs"
    dir_symlink "$dotfiles/vim" "$XDG_CONFIG_HOME/vim"


    symlink "$dotfiles/nvim" "$XDG_CONFIG_HOME/nvim"
    symlink "$dotfiles/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
    symlink "$dotfiles/fish/fishfile" "$XDG_CONFIG_HOME/fish/fishfile"
    dir_symlink "$dotfiles/fish/functions" "$XDG_CONFIG_HOME/fish/functions"
    dir_symlink "$dotfiles/zsh/functions" "$ZDOTDIR/functions"
    for file in `ls -1 "$dotfiles/zsh/" | grep \.zsh$`; do
        symlink "$dotfiles/zsh/$file" "$ZDOTDIR/$file"
    done

    symlink "$dotfiles/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
    symlink "$dotfiles/zsh/zshrc" "$ZDOTDIR/.zshrc"
    symlink "$dotfiles/zsh/zprofile" "$ZDOTDIR/.zprofile"
    symlink "$dotfiles/zshenv" "$HOME/.zshenv"
    symlink "$dotfiles/zprofile" "$HOME/.bash_profile"
    symlink "$dotfiles/npmrc" "$XDG_CONFIG_HOME/npm/npmrc"
    symlink "$dotfiles/inputrc" "$XDG_CONFIG_HOME/readline/inputrc"
    symlink "$dotfiles/ranger" "$XDG_CONFIG_HOME/ranger"
    if has ranger && ! dir_exists "$dotfiles/ranger/plugins/ranger_devicons"; then
        git clone https://github.com/alexanderjeurissen/ranger_devicons "$dotfiles/ranger/plugins/ranger_devicons"
        cd "$dotfiles/ranger/plugins/ranger_devicons"
        make install
    fi
    if file_exists "$dotfiles/nord-gnome-terminal/src/nord.sh"; then
        bash "$dotfiles/nord-gnome-terminal/src/nord.sh"
    fi
}
init() {
    echo "[INFO] start init"
    git config --global alias.s status
    git config --global alias.d diff
    git config --global alias.unstage "reset HEAD"

    if has fish && ! file_exists "$XDG_CONFIG_HOME/fish/functions/fisher.fish"; then
        curl -Lo "$XDG_CONFIG_HOME/fish/functions/fisher.fish" --create-dirs https://git.io/fisher
    fi

    if ! dir_exists "$XDG_CONFIG_HOME/tmux/plugins/tpm"; then
        git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"
    fi

    if ! file_exists "$XDG_CONFIG_HOME/fish/config.local.fish"; then
        {
            echo 'set -x NODEBREW_ROOT $HOME/.nodebrew'
            echo 'set NVIM /usr/share/nvim'
            echo 'set -x NVIM $NVIM'
        } > "$XDG_CONFIG_HOME/fish/config.local.fish"
    fi
    if ! file_exists "$ZDOTDIR/.zshrc.local"; then
        echo 'export NVIM=/usr/share/nvim' > "$ZDOTDIR/.zshrc.local"
    fi
    if ! dir_exists "$HOME/.emacs.d"; then
        git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
    fi

}
# check the requirements
if ! has git || ! has zsh || (! has nvim && ! file_exists "$HOME/local/nvim/bin/nvim") || ! has tmux; then
    if ! has git; then
        echo "you must install git!"
    fi
    if ! has zsh; then
        echo "you must install zsh!"
    fi
    if ! has nvim; then
        echo "you must install neovim! please see installing-neovim : https://github.com/neovim/neovim/wiki/Installing-Neovim"
    fi
    if ! has tmux; then
        echo "you must install tmux!"
    fi
    exit 1
fi

if ! dir_exists "$XDG_CACHE_HOME/zplug"; then
    echo "[INFO] install zplug"
    git clone https://github.com/zplug/zplug "$XDG_CACHE_HOME/zplug"
    zsh "$XDG_CACHE_HOME/zplug/init.zsh"
fi
if ! dir_exists "$XDG_CACHE_HOME/fzf"; then
    echo "[INFO] install fzf"
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
