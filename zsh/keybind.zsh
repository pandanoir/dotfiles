# コマンドラインをエディタで編集する関数
edit-command-line() {
  # 現在のコマンドラインを一時ファイルに書き出す
  local tmpfile=$(mktemp)
  print -rl -- $BUFFER > $tmpfile

  $EDITOR $tmpfile < /dev/tty

  # エディタが正常に終了した場合、一時ファイルの内容でコマンドラインを置き換え
  if [[ $? -eq 0 ]]; then
    BUFFER=$(<$tmpfile)
    zle reset-prompt
  fi

  rm -f $tmpfile
}

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
bindkey '^W' fzf-file-widget

__fsel2() {
  local item

  git status --porcelain --untracked-files |
    fzf +s +m -e --multi --ansi --reverse --height 40% --preview='git diff --color $('"echo {} | awk '{print substr(\$0,4)}') | tail -n +5" |
    awk '{print substr($0,4)}' |
    while read item; do
      echo -n "${(q)item} "
    done
    local ret=$?
  echo
  return $ret
}
fzf-git-edited-widget() {
  LBUFFER="${LBUFFER}$(__fsel2)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-git-edited-widget
bindkey '^X^W' fzf-git-edited-widget
