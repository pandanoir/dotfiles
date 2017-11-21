# setup

```
$ curl -sL dot.pandanoir.net | sh
```

# setup Neovim

install Neovim

```sh
$ pip3 install neovim
$ vim
```

# install list

* zsh
* zplug
* fish
* neovim
* tmux

# setting

```sh
$ {
    echo 'set -x NODEBREW_ROOT ~/.nodebrew'
    echo 'set NVIM /usr/share/nvim'
    echo 'set -x NVIM $NVIM'
    } >~/.config/fish/config.local.fish
$ echo 'export NVIM=/usr/share/nvim' > ~/.zshrc.local
```

code with fish
```sh
$ begin
    echo 'set -x NODEBREW_ROOT ~/.nodebrew'
    echo 'set NVIM /usr/share/nvim'
    echo 'set -x NVIM $NVIM'
end >~/.config/fish/config.local.fish
$ echo 'export NVIM=/usr/share/nvim' > ~/.zshrc.local
```
