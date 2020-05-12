# 挙動:
# 1. 何もセッションが存在しない -> new-session
# 1. SSH先にすでにattachしたセッションが存在する -> detach済みセッションがあればattach、なければnew-session
# 1. ローカルで新しく端末を立ち上げる(=すでにattachしたセッションが存在する) -> tmuxを起動したくない
# -> ローカルとSSH先を区別する必要がある

launch_tmux() {
    if [ `whoami` != 'root' -a -z "$TMUX" -a -z "$STY" -a ! -v IS_VSCODE ]; then
        if type tmux >/dev/null 2>&1; then
            if tmux has-session; then
                if [[ -n `tmux list-sessions | grep '(attached)'` ]]; then
                    # アタッチ済み
                    if [ ! -v NOT_NEW_SESSION_TMUX ]; then
                        if [[ -n `tmux list-sessions | grep -v '(attached)'` ]]; then
                            # デタッチ済みセッションがある
                            exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf attach && echo "tmux attached session"
                        else
                            exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session && echo "tmux created new session"
                        fi
                    fi
                else
                    exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf attach && echo "tmux attached session"
                fi
            else
                exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session && echo "tmux created new session"
            fi
        elif type screen >/dev/null 2>&1; then
            screen -rx || screen -D -RR
        fi
    fi
}
launch_tmux
