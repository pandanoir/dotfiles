notify "setup javascript..."

export DENO_INSTALL="$HOME/.deno"
add_to_path_if_not_exists "$DENO_INSTALL/bin"

export NODE_PATH=/usr/local/lib/node_modules
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
add_to_path_if_not_exists /usr/local/share/npm/bin

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
