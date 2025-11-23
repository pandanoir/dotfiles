alias mv='mv -i'
alias cp='cp -i'
alias cdb='cd-bookmark'
if command_exists pbcopy; then
  alias copy='pbcopy'
else
  alias copy='xsel --clipboard --input'
fi
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

reitou() {
  if [ "$#" -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo 'Usage: reitou [対象ディレクトリ/ファイル] [tarファイル名]'
    echo 'Example: reitou /path/to/directory archive.tar.gz'
  else
    tar -zcvf "$2" "$1"
  fi
}
alias kaitou='tar -xvf'
alias sourcez="source $ZDOTDIR/.zprofile; source $ZDOTDIR/.zshrc"

alias ts-node-esm='TS_NODE_COMPILER_OPTIONS="{\"module\":\"commonjs\"}" npx ts-node'

# Git 基本操作
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gdw='git diff -w'
alias gdc='git diff --cached'
alias gdcw='git diff --cached -w'
alias gl='git log --graph --oneline --abbrev-commit'
alias gtr='git log --color=always --graph --abbrev-commit --oneline'

# ブランチ操作
alias gbr='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias gfw='git fetch && git switch'
fbr() {
  git branch | fzf +s +m -e --ansi --reverse | sed -e 's/^ *//' -e 's/^\* //'
}

# コミット関連
alias ga='git add'
alias gc='git commit'
alias gcam='git commit --amend'
alias gcp='git cherry-pick'
alias git-soft-reset='git reset --soft HEAD^'
alias git-hard-reset='git reset --hard HEAD^'

# リモート操作
alias gp='git push'
alias gpo='git push origin HEAD -u'
alias gpl='git pull'
alias gf='git fetch'
gfo() {
  git fetch origin "$1:$1"
}

# Git その他操作
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
alias -g L='| less'
alias -g S='| sort'
alias -g SU='| sort -u'
alias -g E="| xargs $EDITOR"

if command_exists nvim; then
  alias vi="\\vim"
  alias vim='nvim'
  alias less="$(nvim --noplugin --headless +'echo $VIMRUNTIME' +q 2>&1)/scripts/less.sh"
  alias memo='NVIM_APPNAME=nvim-memo nvim'
  alias mo='memo'
  alias -g V='| xargs nvim'
fi

if command_exists eza; then
  alias ls='eza --group-directories-first --icons=always'
  alias ll='eza --group-directories-first --icons=always -algh --git'
  alias lg='eza --group-directories-first --icons=always --git-ignore'
  function chpwd() { eza --group-directories-first --icons=always }
else
  if is_mac; then
    alias ls='ls -G'
    alias ll='ls -l -G'
    function chpwd() { ls -G }
  else
    alias ls='ls --color=always'
    alias ll='ls -l --color=always'
    function chpwd() { ls --color=auto }
  fi
fi
if command_exists bat; then alias cat='bat'; fi
if command_exists ranger; then
  alias ra='ranger'
  alias rang='ranger'
fi
if command_exists rg; then
  alias rgf='rg --files | sort | rg'
  alias -g R='| xargs rg'
fi
