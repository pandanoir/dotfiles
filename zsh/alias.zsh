alias mv='mv -i'
alias cp='cp -i'
alias cdb='cd-bookmark'
alias ekill="emacsclient -e '(kill-emacs)'"
alias erestart="ekill && estart"
alias copy='xsel --clipboard --input'
alias cl='clear'
alias cle='clear'
alias clea='clear'
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --cached'
alias gs='git status'
alias gp='git push'
alias gc='git commit'

alias -g A='| awk'
alias -g C='| copy' # copy
alias -g L='| $VIM/runtime/macros/less.sh -R'
alias -g S='| sort'
alias -g U='| uniq'
alias -g X='| xargs'
alias -g bgh=">/dev/null"

alias -g .zshrc="$ZDOTDIR/.zshrc"
alias -g .zsh="$ZDOTDIR/.zshrc"

alias -g .zprofile="$ZDOTDIR/.zprofile"
alias -g .zp="$ZDOTDIR/.zprofile"
alias -g .zpr="$ZDOTDIR/.zprofile"
alias -g .zpro="$ZDOTDIR/.zprofile"

# vim_version=`vim --version | head -1 | sed 's/^.*\ \([0-9]\)\.\([0-9]\)\ .*$/\1\2/'`
alias emacs='emacs -nw'
alias e='emacsclient -nw -a "" 2>/dev/null'

alias vi="env -u VIM env VIMINIT=':source $XDG_CONFIG_HOME'/vim/vimrc vim"
alias vim="env -u VIM env VIMINIT=':source $XDG_CONFIG_HOME'/vim/vimrc vim"

if command_exists nvim; then
    alias vim="nvim"
fi
if command_exists exa; then
    alias ls="exa"
    alias ll='exa -algh --git'
    alias lg='exa --git-ignore'
    function chpwd() { exa }
fi
if command_exists bat; then alias cat='bat'; fi
