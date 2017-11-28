has() {
    type "$1" > /dev/null 2>&1
}
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home
export PATH=/opt/local/bin
export PATH=$PATH:/opt/local/sbin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/bin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/sbin
export PATH=$PATH:/opt/X11/bin
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/opt/python3/bin

export JAVA_HOME
export PATH=$PATH:${JAVA_HOME}/bin

# VIM=/usr/local/Cellar/vim/8.0.0946/share/vim/vim80
export VIM=/usr/share/vim/vim74
export EDITOR=nvim

export CPLUS_INCLUDE_PATH=/opt/local/include
# node_modules
export NODE_PATH=/usr/local/lib/node_modules
export PATH=$PATH:/usr/local/share/npm/bin
export LC_ALL=en_US.UTF-8

if has perl; then
    eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)
end

if has plenv; then
    export PLENV_ROOT="${HOME}/.plenv"
    export PATH=${PLENV_ROOT}/shims:${PATH}
    eval "$(plenv init -)";
end

if has rbenv; then
    eval "$(rbenv init -)"
end

if has nodebrew; then
    export PATH=$PATH:$HOME/.nodebrew/current/bin
end

export GTK_IM_MODULE=uim
export LANG=ja_JP.UTF-8
export XMODIFIERS=@im=uim
export TERM=xterm-256color
