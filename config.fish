set -x PATH $PATH /usr/local/bin
set -x PATH $PATH /usr/bin
set -x PATH $PATH /bin
set -x PATH $PATH /usr/sbin
set -x PATH $PATH /sbin
set JAVA_HOME /usr/java/jdk-9
set -x PATH $PATH $JAVA_HOME/bin

set VIM /usr/share/vim/vim74
set -x VIM $VIM
set EDITOR nvim
set -x EDITOR $EDITOR

set -x CPLUS_INCLUDE_PATH /opt/local/include
# node_modules
set -x NODE_PATH $HOME/.nodebrew/current/lib/node_modules
set -x LC_ALL en_US.UTF-8


set -x PATH $PATH $HOME/.nodebrew/current/bin


set -x GTK_IM_MODULE uim
set -x LANG ja_JP.UTF-8
set -x XMODIFIERS @im=uim



set -x LANG ja_JP.UTF-8
set -x NPM_TOKEN 25f46656-1c38-4688-8151-b6226680a174

set -x TERM xterm-256color

alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ../'
alias ...='cd ../../'
alias vi='command vim'
alias vim='env VIM=/usr/local/share/nvim nvim'
alias ag='ag -m1 -l --silent'

function my_pwd_changed --on-variable PWD
    ls
end

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
