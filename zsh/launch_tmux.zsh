# 挙動:
# 1. 何もセッションが存在しない -> new-session
# 1. SSH先にすでにattachしたセッションが存在する -> detach済みセッションがあればattach、なければnew-session
# 1. ローカルで新しく端末を立ち上げる(=すでにattachしたセッションが存在する) -> tmuxを起動したくない
# -> ローカルとSSH先を区別する必要がある

source "$ZDOTDIR/utils.zsh"
launch_tmux() {
  if ! is_empty_string "$(tmux list-sessions | grep -v popup | grep -v '(attached)')"; then
    exec tmux attach # アタッチされていないセッションがある
  fi

  if [ -v NOT_NEW_SESSION_TMUX ]; then
    # 新しいセッションを立ち上げたくない
    echo "detached tmux session doesn't exist"
    return
  fi

  exec tmux new-session
}
launch_tmux
