autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER=" fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# ^G: git変更ファイルをfzfで選択してカーソル位置に挿入
# 表示: "ステータス ファイル名  ディレクトリ" / preview: git diff
__fzf_git_files() {
  local item

  git status --short --untracked-files |
    awk -F/ 'OFS="/"{file=$NF; $NF=""; dir=substr($0,4); status=substr($0,0,3); print status file "  \033[90m" dir "\033[0m"}' |
    $(__fzfcmd) +s +m -e --multi --ansi --reverse --preview='git diff --color $('"echo {} | awk -F '  ' 'OFS=\"  \"{dir=\$NF; \$NF=\"\"; print dir substr(\$0,4)}') | tail -n +5" |
    awk -F"  " 'OFS="  "{dir=$NF; $NF=""; print dir substr($0,4)}' |
    while read item; do
      echo -n "${(q)item} "
    done
    local ret=$?
  echo
  return $ret
}
fzf-git-files-widget() {
  LBUFFER="${LBUFFER}$(__fzf_git_files)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-git-files-widget
bindkey '^G' fzf-git-files-widget

# ^S: ブランチをfzfで選択してカーソル位置に挿入
# 表示: "ブランチ名  最終コミット日時  コミットメッセージ" (新しい順)
# preview: そのブランチの直近コミット履歴
__fzf_local_branch() {
  local item
  git for-each-ref --sort=-committerdate refs/heads/ \
    --format=$'%(refname:short)\t%(committerdate:relative)\t%(subject)' |
    awk -F'\t' '{printf "%s  \033[33m%s\033[0m  \033[90m%s\033[0m\n", $1, $2, $3}' |
    $(__fzfcmd) +s +m -e --ansi --reverse \
      --preview='git log --oneline --graph --decorate --color -20 {1}' \
      --preview-window=right:50% |
    awk '{print $1}' | while read item; do
      echo -n "${(q)item} "
    done
  local ret=$?
  echo
  return $ret
}
fzf-local-branch-widget() {
  LBUFFER="${LBUFFER}$(__fzf_local_branch)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-local-branch-widget
bindkey '^S' fzf-local-branch-widget
# フロー制御を無効化して ^S を使えるようにする
stty -ixon


# ^T/^W: ファイルをfzfで選択してカーソル位置に挿入
# 表示: "ファイル名  ディレクトリ" (ファイル名先頭で検索しやすい) / preview: bat
__fzf_files() {
  local item

  rg --files --hidden --follow --glob '!.git/*' |
    awk -F/ 'OFS="/"{file=$NF; $NF=""; dir=$0; print file "  \033[90m" $0 "\033[0m"}' |
    $(__fzfcmd) +s +m -e --multi --ansi --reverse --with-nth=1.. --preview="bat --color=always --style=header,grid --line-range :100 {2..}{1}" |
    awk -F"  " 'OFS=" "{file=$1; $1=""; print $0 file}' |
    sed 's/^ //' |
    while read item; do
      echo -n "${(q)item} "
    done
    local ret=$?
  echo
  return $ret
}
fzf-files-widget() {
  LBUFFER="${LBUFFER}$(__fzf_files)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-files-widget
bindkey '^T' fzf-files-widget
bindkey '^W' fzf-files-widget

# スペース: 大文字エイリアスをその場で展開 (例: "git L" → "git log ...")
globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}
zle -N globalias
bindkey " " globalias
