export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export HISTFILE="$XDG_DATA_HOME/zsh/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export CD_BOOKMARK_FILE="$XDG_DATA_HOME/zsh/cdbookmark"

export COMMANDLINE_EDITOR="vi -c 'setf shell'"
export MULTIPLEXER="tmux"
export TMUX_AUTO_LAUNCH="true"
export ZELLIJ_AUTO_ATTACH="true"
export ZELLIJ_AUTO_EXIT="true"

export DOTDIR="$HOME/dotfiles"

export EDITOR="vim"
if command_exists nvim; then
  export MANPAGER="col -b -x | $(nvim --noplugin --headless +'echo $VIMRUNTIME' +q 2>&1)/scripts/less.sh -c 'setf man'"
  export EDITOR="nvim"
fi
