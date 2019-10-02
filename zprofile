has() {
    type "$1" > /dev/null 2>&1
}
export TERM=xterm-256color
path=(
    $path
    "/opt/local/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "$HOME/.local/bin"
    "$HOME/local/nvim/bin"
)
fpath=($XDG_CONFIG_HOME/zsh/functions/*(N-/) $fpath)

export ZPLUG_HOME=$XDG_CACHE_HOME/zplug
export HISTFILE=$XDG_DATA_HOME/zsh/history
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export CD_BOOKMARK_FILE=$XDG_DATA_HOME/zsh/cdbookmark


# Java
JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export JAVA_HOME
export PATH=$PATH:${JAVA_HOME}/bin

# go
GOPATH=$HOME/go
export GOPATH
export PATH=$PATH:$GOPATH/bin

# rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

export VIM=/usr/share/nvim
export EDITOR=$(which nvim)

# cpp
export CPLUS_INCLUDE_PATH=/opt/local/include

# node_modules
export NODE_PATH=/usr/local/lib/node_modules
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PATH=$PATH:/usr/local/share/npm/bin
export LC_ALL=ja_JP.UTF-8

if has plenv; then
    export PLENV_ROOT=$HOME/.plenv
    export PATH=${PLENV_ROOT}/shims:${PATH}
    eval "$(plenv init -)";
fi

if has rbenv; then
    eval "$(rbenv init -)"
fi

if [ -d $HOME/.nodebrew ]; then
    export NODE_PATH=$HOME/.nodebrew/current/lib/node_modules
    export PATH=$PATH:$HOME/.nodebrew/current/bin
    export PATH=$PATH:$XDG_DATA_HOME/npm/bin
fi
if [ -d $HOME/.yarn ]; then
    export PATH=$HOME/.yarn/bin:$PATH
fi
if [ -d $HOME/.config/yarn ]; then
    export PATH=$HOME/.config/yarn/global/node_modules/.bin:$PATH
fi

if [ -d $HOME/.cargo ]; then
    export PATH=$HOME/.cargo/bin:$PATH
fi
if [ -d $XDG_DATA_HOME/cargo ]; then
    CARGO_HOME="$XDG_DATA_HOME"/cargo
    export CARGO_HOME=$CARGO_HOME
    export PATH=$CARGO_HOME/bin:$PATH
fi

export LANG=ja_JP.UTF-8

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export PATH=`echo -n $PATH | tr : '\n' | awk '!a[$0]++' | xargs | tr ' ' :`
# export FZF_DEFAULT_OPTS="--reverse -m"
export FZF_DEFAULT_COMMAND="ag -g ''"
export FZF_CTRL_T_COMMAND="ag -g ''"

[ -f $ZDOTDIR/.zprofile.local ] && source $ZDOTDIR/.zprofile.local
