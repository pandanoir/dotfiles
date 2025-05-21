is_terminal_app() {
  [ $(whoami) != "root" ] &&
  [[ "$TERM_PROGRAM" == "WezTerm" ]] &&
  is_empty_string "$STY" &&
  is_empty_string $GITHUB_ACTIONS
}

if is_terminal_app &&
  [[ "$MULTIPLEXER" == "tmux" ]] &&
  command_exists tmux &&
  is_empty_string "$TMUX" &&
  [[ "$TMUX_AUTO_LAUNCH" == "true" ]]; then
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

if is_terminal_app &&
  [[ "$MULTIPLEXER" == "zellij" ]] &&
  command_exists zellij &&
  is_empty_string "$ZELLIJ"; then
  if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
    zellij attach -c main
  else
    zellij
  fi

  if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
    exit
  fi
fi
