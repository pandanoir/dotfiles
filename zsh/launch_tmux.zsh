# 挙動:
# 1. 何もセッションが存在しない -> new-session
# 1. SSH先にすでにattachしたセッションが存在する -> detach済みセッションがあればattach、なければnew-session
# 1. ローカルで新しく端末を立ち上げる(=すでにattachしたセッションが存在する) -> tmuxを起動したくない
# -> ローカルとSSH先を区別する必要がある

launch_tmux() {
    if [ `whoami` = 'root' ] || ! is_empty_string "$TMUX" || ! is_empty_string "$STY" || [ -v IS_VSCODE ]; then
        return
    fi

    if ! type tmux >/dev/null 2>&1; then
        if type screen >/dev/null 2>&1; then
            screen -rx || screen -D -RR
        fi
        return
    fi
    if ! tmux has-session; then
        exec tmux new-session && echo "tmux created new session"
    fi
    if ! [[ -n `tmux list-sessions | grep '(attached)'` ]]; then
        exec tmux attach && echo "tmux attached session"
    fi
    # アタッチ済み
    if [ -v NOT_NEW_SESSION_TMUX ]; then
        echo "detached tmux session doesn't exist"
        return
    fi
    if [[ -n `tmux list-sessions | grep -v '(attached)'` ]]; then
        # デタッチ済みセッションがある
        exec tmux attach && echo "tmux attached session"
    else
        exec tmux new-session && echo "tmux created new session"
    fi
}
launch_tmux
