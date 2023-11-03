[![linux](https://github.com/pandanoir/dotfiles/actions/workflows/test-linux.yml/badge.svg?branch=master)](https://github.com/pandanoir/dotfiles/actions/workflows/test-linux.yml)

# setup

```
$ curl -sL dot.pandanoir.net | bash
$ http -F dot.pandanoir.net | bash
```

# setup Neovim

install Neovim

```sh
$ pip3 install neovim
$ vim
```

# install list

* zsh
* zinit
* neovim
* tmux

# vimrc and bashrc
you can download minimal vimrc and bashrc from pandanoir.net

```
$ curl -L pandanoir.net/vimrc -o ~/.vimrc
$ curl -L pandanoir.net/bashrc -o ~/.bashrc.mini && echo "source ~/.bashrc.mini >> ~/.bashrc"
$ http -F pandanoir.net/vimrc -o ~/.vimrc
$ http -F pandanoir.net/bashrc -o ~/.bashrc.mini && echo "source ~/.bashrc.mini >> ~/.bashrc"
```

# handy tools

* exa: alternative ls.
* bat: alternative cat.
* httpie: HTTP client. easier to use than curl or wget.
* ranger: filer.
* tty-clock: digital clock on terminal.

on Ubuntu:

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ cargo install exa bat
$ git clone https://github.com/neovim/neovim ~/Documents/neovim
$ cd ~/Documents/neovim && make CMAKE_INSTALL_PREFIX=$HOME/local/nvim CMAKE_BUILD_TYPE=RelWithDebInfo install
$ sudo apt install httpie ranger tty-clock
```

on CentOS:

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ cargo install exa bat
$ git clone https://github.com/neovim/neovim ~/Documents/neovim
$ cd ~/Documents/neovim && make CMAKE_INSTALL_PREFIX=$HOME/local/nvim CMAKE_BUILD_TYPE=RelWithDebInfo install
$ sudo dnf install httpie ranger tty-clock
```
