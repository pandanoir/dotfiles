# HACK: janoamaral/tokyo-night-tmuxはそのままだとウィンドウの区切りが設定されないので、手動で設定している

tmux setw -g window-status-separator " "

current_current_fmt=$(tmux show-options -g window-status-current-format | cut -d ' ' -f 2- | sed 's/^"//; s/"$//')
tmux setw -g window-status-current-format "#[fg=#1a1b26,bg=#2A2F41]${current_current_fmt}#[fg=#1a1b26]"

current_status_left=$(tmux show-options -g status-left | cut -d ' ' -f 2- | sed 's/^"//; s/"$//')
tmux setw -g status-left "${current_status_left}#[fg=#1a1b26]"
