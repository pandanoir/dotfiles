notify "setup fzf..."
if dir_exists $XDG_CACHE_HOME/fzf/bin; then
  add_to_path_if_not_exists "$XDG_CACHE_HOME/fzf/bin"
fi

# fzfをtmux popupで開く (https://zenn.dev/eetann/articles/2022-03-19-fzf-tmux-popup)
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%"

export FZF_DEFAULT_OPTS="--reverse -m --ansi --color='
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
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
elif command_exists ag; then
  export FZF_DEFAULT_COMMAND="ag -g ''"
else
  unset FZF_DEFAULT_COMMAND
fi
