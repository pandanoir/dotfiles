alias mv='mv -i'
alias cp='cp -i'
alias cdb='cd-bookmark'
if has pbcopy; then
  alias copy="pbcopy"
else
  alias copy='xsel --clipboard --input'
fi
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

alias g='git'
alias ga='git add'
alias gbr='git branch'
alias gd='git diff'
alias gdw='git diff -w'
alias gdc='git diff --cached'
alias gdcw='git diff --cached -w'
alias gs='git status'
alias gsp='git status --porcelain'
alias gp='git push'
alias gpo='git push origin HEAD -u'
alias gpl="git pull"
alias gc='git commit'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gsw='git switch'
alias gb='git branch'
alias gl='git log --graph --oneline --abbrev-commit'
alias gtr='git log --color=always --graph --abbrev-commit --oneline'
alias gsw='git switch'
alias gre='git restore'
gro() {
  git rebase origin/$(git symbolic-ref --short HEAD)
}
git-rm-merged-branch() {
git branch --merged | grep -v '^*' | grep -v 'master' | xargs git branch -d
}
git-set-upstream-branch() {
git branch --set-upstream-to="origin/$(git branch --show-current)"
}

fcs() {
  local commits commit
  commits=$(git --no-pager log --color=always --all --oneline --abbrev-commit --decorate=full 2>&1) &&
    commit=$(echo "$commits" | fzf +s +m -e --ansi --reverse) &&
    echo -n $(echo "$commit" | sed "s/ .*//")
}
fbr() {
  git branch | fzf +s +m -e --ansi --reverse | sed -e 's/^ *//' -e 's/^\* //'
}

globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}

zle -N globalias

bindkey " " globalias

alias -g A='| awk'
alias -g C='| copy'
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

alias vi="env -u VIM env VIMINIT=':source $XDG_CONFIG_HOME'/vim/vimrc vim"
alias vim="env -u VIM env VIMINIT=':source $XDG_CONFIG_HOME'/vim/vimrc vim"

if command_exists nvim; then
  alias vim="nvim"
fi
if command_exists exa; then
  alias ls="exa --group-directories-first"
  alias ll='exa --group-directories-first -algh --git'
  alias lg='exa --group-directories-first --git-ignore'
  function chpwd() { exa --group-directories-first }
else
  if is_mac; then
    alias ls='ls -G'
    alias ll='ls -l -G'
  else
    alias ls='ls --color=always'
    alias ll='ls -l --color=always'
  fi
  alias lg='exa --git-ignore'
fi
if command_exists bat; then alias cat='bat'; fi
if command_exists ranger; then
  alias ra="ranger"
  alias rang="ranger"
fi
if command_exists rg; then
  alias rgf="rg --files | rg"
fi
