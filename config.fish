# scp command will be broken if tmux is running.
# so if shell is not interactive, finish fish.
status --is-interactive; or exit

if [ -z "$TMUX" -a -z "$STY" ]
    if type tmuxx >/dev/null 2>&1
        tmuxx
    else if type tmux >/dev/null 2>&1
        if tmux has-session; and tmux list-sessions | egrep -q '.*]$'
            # デタッチ済みセッションが存在する
            tmux attach
            echo "tmux attached session "
        else
            tmux new-session
            echo "tmux created new session"
        end
    else if type screen >/dev/null 2>&1
        screen -rx; or screen -D -RR
    end
end

function post_ssh --on-event fish_postexec
    # ssh切断時にclearする
    if echo $argv | string match -r "^ssh"
        clear
    end
end

alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ../'
alias ...='cd ../../'
alias vi='env VIM=/usr/share/vim/vim74 command vim'
alias vim='nvim'
alias ag='ag -m1 -l --silent'

function my_pwd_changed --on-variable PWD
    ls
end

[ -f $HOME/.config/fish/config.local.fish ]; and source $HOME/.config/fish/config.local.fish
