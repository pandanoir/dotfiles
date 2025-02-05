if [[ "$MULTIPLEXER" == "tmux" ]] &&
  command_exists tmux &&
  [ $(whoami) != "root" ] &&
  [[ "$TMUX_AUTO_LAUNCH" == "true" ]] &&
  is_empty_string "$TMUX" &&
  is_empty_string "$STY" &&
  is_empty_string $IS_VSCODE &&
  is_empty_string $GITHUB_ACTIONS; then
  # アタッチされていないセッションがあったらアタッチする
  if ! is_empty_string "$(tmux list-sessions | grep -v popup | grep -v '(attached)')"; then
    exec tmux attach
  elif [ -v NOT_NEW_SESSION_TMUX ]; then
    # 新しいセッションを立ち上げたくない
    echo "detached tmux session doesn't exist"
  else
    exec tmux new-session
  fi
  exit
fi

if [[ "$MULTIPLEXER" == "zellij" ]] && command_exists zellij && [[ -z "$ZELLIJ" ]]; then
  if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
    zellij attach -c main
  else
    zellij
  fi

  if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
    exit
  fi
fi
