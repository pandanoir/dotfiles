JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home
export JAVA_HOME

PATH=${JAVA_HOME}/bin:$PATH
export PATH

# VIM=/usr/share/vim/vim73
VIM=/usr/local/Cellar/vim/8.0.0946/share/vim/vim80
export VIM

export CPLUS_INCLUDE_PATH=/opt/local/include
# node_modules
export NODE_PATH=/usr/local/lib/node_modules
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/share/npm/bin
export LC_ALL=en_US.UTF-8

eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)

if which plenv > /dev/null; then
    export PLENV_ROOT="${HOME}/.plenv"
    export PATH=${PLENV_ROOT}/shims:${PATH}
    eval "$(plenv init -)";
fi

# MacPorts Installer addition on 2014-03-28_at_17:22:58: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export PATH=/opt/local/bin:/opt/local/sbin:/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/mysql/bin
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/python3/bin:$PATH"
eval "$(rbenv init -)"


export GTK_IM_MODULE=uim
export LANG=ja_JP.UTF-8
export XMODIFIERS=@im=uim
