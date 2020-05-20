# 挙動:
# 1. 何もセッションが存在しない -> new-session
# 1. SSH先にすでにattachしたセッションが存在する -> detach済みセッションがあればattach、なければnew-session
# 1. ローカルで新しく端末を立ち上げる(=すでにattachしたセッションが存在する) -> tmuxを起動したくない
# -> ローカルとSSH先を区別する必要がある

source "$ZDOTDIR/utils.zsh"
launch_tmux() {
    if [ `whoami` = 'root' ] || ! is_empty_string "$TMUX" || ! is_empty_string "$STY" || [ -v IS_VSCODE ]; then
        return
    fi

    if ! has tmux; then
        # そもそもtmuxがない
        return
    fi
    if ! tmux has-session; then
        exec tmux new-session # セッションがない
    fi
    if is_empty_string "$(tmux list-sessions | grep '(attached)')"; then
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
