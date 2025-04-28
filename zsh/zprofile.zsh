source "$ZDOTDIR/utils.zsh"
add_to_path_if_not_exists "$HOME/.local/bin"
add_to_path_if_not_exists "$HOME/local/nvim/bin"
add_to_path_if_not_exists /opt/local/bin
add_to_path_if_not_exists /usr/local/bin
add_to_path_if_not_exists /usr/bin
add_to_path_if_not_exists /bin
add_to_path_if_not_exists /usr/sbin
add_to_path_if_not_exists /sbin

export LANG=ja_JP.UTF-8

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

if command_exists nvim; then
  notify "setup nvim..."
  export MANPAGER="col -b -x | $(nvim --headless +'echo $VIMRUNTIME' +q 2>&1)/macros/less.sh -c 'setf man'"
  export EDITOR=$(which nvim)
else
  export EDITOR=$(which vim)
fi

if file_exists /opt/homebrew/bin/brew; then
  notify "setup brew..."
  eval "$(/opt/homebrew/bin/brew shellenv)" # homebrew関連の環境変数をセット
fi

# javascript ============================
notify "setup javascript..."
export DENO_INSTALL="$HOME/.deno"
add_to_path_if_not_exists "$DENO_INSTALL/bin"

export NODE_PATH=/usr/local/lib/node_modules
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
add_to_path_if_not_exists /usr/local/share/npm/bin
export LC_ALL=ja_JP.UTF-8

VOLTA_HOME="$HOME/.volta"
if dir_exists "$VOLTA_HOME"; then
  export VOLTA_HOME
  add_to_path_if_not_exists "$VOLTA_HOME/bin"
fi

if dir_exists $HOME/.nodebrew; then
  export NODE_PATH="$HOME/.nodebrew/current/lib/node_modules"
  add_to_path_if_not_exists "$HOME/.nodebrew/current/bin"
fi
add_to_path_if_not_exists "$XDG_DATA_HOME/npm/bin"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if dir_exists $HOME/.yarn; then
  add_to_path_if_not_exists "$HOME/.yarn/bin"
fi
if dir_exists $HOME/.config/yarn; then
  add_to_path_if_not_exists "$HOME/.config/yarn/global/node_modules/.bin"
fi

# java ============================
notify "setup java..."
if dir_exists /usr/bin/javac; then
  JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
  export JAVA_HOME
  add_to_path_if_not_exists "${JAVA_HOME}/bin"
fi
if dir_exists /usr/bin/java; then
  JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
  export JAVA_HOME
  add_to_path_if_not_exists "$JAVA_HOME"
fi

# go ============================
notify "setup go..."
GOPATH="$HOME/go"
if dir_exists "$GOPATH"; then
  export GOPATH
  add_to_path_if_not_exists "$GOPATH/bin"
fi

# rust ============================
notify "setup rust..."
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

if dir_exists $HOME/.cargo; then
  add_to_path_if_not_exists "$HOME/.cargo/bin"
  source "$HOME/.cargo/env"
  . "$HOME/.cargo/env"
fi
if dir_exists $XDG_DATA_HOME/cargo; then
  CARGO_HOME="$XDG_DATA_HOME"/cargo
  export CARGO_HOME=$CARGO_HOME
  add_to_path_if_not_exists "$CARGO_HOME/bin"
fi

# cpp ============================
export CPLUS_INCLUDE_PATH=/opt/local/include

# perl ============================
if command_exists plenv; then
  export PLENV_ROOT="$HOME/.plenv"
  add_to_path_if_not_exists "${PLENV_ROOT}/shims"
  eval "$(plenv init -)"
fi

# ruby ============================
notify "setup ruby..."
RBENV_ROOT="$XDG_DATA_HOME/rbenv"
if file_exists "$RBENV_ROOT/bin/rbenv"; then
  export RBENV_ROOT
  add_to_path_if_not_exists "$RBENV_ROOT/bin"
  eval "$(rbenv init -)"
fi

# fzf ============================
notify "setup fzf..."
if dir_exists $XDG_CACHE_HOME/fzf/bin; then
  add_to_path_if_not_exists "$XDG_CACHE_HOME/fzf/bin"
fi

export FZF_DEFAULT_OPTS="--reverse -m --color"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#1e2132,spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6"
export FZF_COMPLETION_TRIGGER=",,"

if command_exists rg; then
  if command_exists bat; then
    export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
  else
    export FZF_CTRL_T_OPTS='--preview cat'
  fi
  FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export RIPGREP_CONFIG_PATH="$HOME/dotfiles/ripgreprc"
elif command_exists ag; then
  export FZF_CTRL_T_OPTS="--preview 'head -n 20 {}'"
  FZF_DEFAULT_COMMAND="ag -g ''"
else
  FZF_DEFAULT_COMMAND=
fi

if ! is_empty_string "$FZF_DEFAULT_COMMAND"; then
  FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND; (echo '$ZDOTDIR/.zshrc' ;echo '$ZDOTDIR/.zprofile')"
  export FZF_DEFAULT_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
else
  unset FZF_DEFAULT_COMMAND
  unset FZF_CTRL_T_COMMAND
fi

source_if_exists "$ZDOTDIR/.zprofile.local"
notify "loaded zprofile"; echo
