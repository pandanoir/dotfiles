alias mv='mv -i'
alias cp='cp -i'
alias cdb='cd-bookmark'
if command_exists pbcopy; then
  alias copy="pbcopy"
else
  alias copy='xsel --clipboard --input'
fi
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
if command_exists nvim; then
  alias less="$(nvim --headless +'echo $VIMRUNTIME' +q 2>&1)/scripts/less.sh"
fi

reitou() {
  if [ "$#" -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: reitou [対象ディレクトリ/ファイル] [tarファイル名]"
    echo "Example: reitou /path/to/directory archive.tar.gz"
  else
    tar -zcvf "$2" "$1"
  fi
}
alias kaitou='tar -xvf'
alias sourcez="source $ZDOTDIR/.zprofile; source $ZDOTDIR/.zshrc"

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
gfo() {
  git fetch origin $1:$1
}
alias gc='git commit'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gb='git branch'
alias gl='git log --graph --oneline --abbrev-commit'
alias gtr='git log --color=always --graph --abbrev-commit --oneline'
alias gsw='git switch'
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
alias -g L="| less"
alias -g S='| sort'
alias -g SU='| sort -u'

if command_exists nvim; then
  alias vi="\\vim"
  alias vim="nvim"
fi

if command_exists eza; then
  alias ls="eza --group-directories-first --icons=always"
  alias ll='eza --group-directories-first --icons=always -algh --git'
  alias lg='eza --group-directories-first --icons=always --git-ignore'
  function chpwd() { eza --group-directories-first --icons=always }
elif command_exists exa; then
  alias ls="exa --group-directories-first"
  alias ll='exa --group-directories-first -algh --git'
  alias lg='exa --group-directories-first --git-ignore'
  function chpwd() { exa --group-directories-first }
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
  alias ra="ranger"
  alias rang="ranger"
fi
if command_exists rg; then
  alias rgf="rg --files | sort | rg"
fi
