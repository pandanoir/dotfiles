alias mv='mv -i'
alias cp='cp -i'
alias cdb='cd-bookmark'
if has pbcopy; then
  alias copy="pbcopy"
else
  alias copy='xsel --clipboard --input'
fi
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

alias reitou='tar -zcvf'
alias kaitou='tar -xvf'

alias ts-node-esm='TS_NODE_COMPILER_OPTIONS="{\"module\":\"commonjs\"}" npx ts-node'

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
alias gf='git fetch'
alias gfs='git fetch && git switch'
alias gfsw='git fetch && git switch'
alias gfw='git fetch && git switch'
alias gc='git commit'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gsw='git switch'
alias gb='git branch'
alias gl='git log --graph --oneline --abbrev-commit'
alias gtr='git log --color=always --graph --abbrev-commit --oneline'
alias gsw='git switch'
alias gswm='git switch master'
alias gre='git restore'
alias git-soft-reset="git reset --soft HEAD^"
alias git-hard-reset="git reset --hard HEAD^"
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
__fsel3() {
  local item
  git branch | fzf +s +m -e --ansi --reverse --height 40% | sed -e 's/^ *//' -e 's/^\* //' | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}
fzf-branch-widget() {
  LBUFFER="${LBUFFER}$(__fsel3)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-branch-widget
bindkey -M emacs '^S' fzf-branch-widget
bindkey -M vicmd '^S' fzf-branch-widget
bindkey -M viins '^S' fzf-branch-widget

globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}

zle -N globalias

bindkey " " globalias

# start development server
function s() {
  if command_exists jq && jq '.scripts|keys[]' -r <package.json | grep dev$; then
    npm run dev
  else
    npm start
  fi
}

alias -g A='| awk'
alias -g C='| copy'
alias -g L="| $VIM/runtime/macros/less.sh -R"
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

if command_exists eza; then
  alias ls="eza --group-directories-first"
  alias ll='eza --group-directories-first -algh --git'
  alias lg='eza --group-directories-first --git-ignore'
  function chpwd() { eza --group-directories-first }
elif command_exists exa; then
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
  alias rgf="rg --files | sort | rg"
fi
