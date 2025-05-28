is_terminal_app() {
  [ $(whoami) != "root" ] &&
  [[ "$TERM_PROGRAM" == "WezTerm" ]] &&
  is_empty_string "$STY" &&
  is_empty_string $GITHUB_ACTIONS
}

if ! is_terminal_app; then
  return
fi

if [[ "$MULTIPLEXER" == "tmux" ]] &&
  command_exists tmux &&
  is_empty_string "$TMUX" &&
  [[ "$TMUX_AUTO_LAUNCH" == "true" ]]; then
  # アタッチされていないセッション(popup以外)があったらアタッチする
  detached_session="$(tmux list-sessions -f '#{?session_attached,0,1}' -F '#S' | grep -v popup | head -n 1)"
  if ! is_empty_string "$detached_session"; then
    exec tmux attach -t "$detached_session"
  elif [ -v NOT_NEW_SESSION_TMUX ]; then
    # 新しいセッションを立ち上げたくない
    echo "detached tmux session doesn't exist"
  else
    exec tmux new-session
  fi
  exit
fi

if [[ "$MULTIPLEXER" == "zellij" ]] &&
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
