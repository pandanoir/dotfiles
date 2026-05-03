notify "setup fzf..."
if dir_exists $XDG_CACHE_HOME/fzf/bin; then
  add_to_path_if_not_exists "$XDG_CACHE_HOME/fzf/bin"
fi

# fzfをtmux popupで開く (https://zenn.dev/eetann/articles/2022-03-19-fzf-tmux-popup)
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"

export FZF_DEFAULT_OPTS="--reverse -m --color='
  bg+:#1e2132 fg:#c6c8d1 fg+:#c6c8d1
  header:#6b7089
  hl:#6b7089 hl+:#84a0c6
  info:#b4be82
  marker:#84a0c6
  pointer:#84a0c6
  prompt:#84a0c6
  spinner:#84a0c6
'"
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
