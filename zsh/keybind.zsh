# コマンドラインをエディタで編集する関数
edit-command-line() {
  # 現在のコマンドラインを一時ファイルに書き出す
  local tmpfile=$(mktemp)
  print -rl -- $BUFFER > $tmpfile

  local EDITOR_CMD=$EDITOR

  # Check if $COMMANDLINE_EDITOR is set
  if [[ -n $COMMANDLINE_EDITOR ]]; then
    EDITOR_CMD=$COMMANDLINE_EDITOR
  fi

  eval $EDITOR_CMD $tmpfile < /dev/tty

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

__fsel2() {
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
fzf-git-edited-widget() {
  LBUFFER="${LBUFFER}$(__fsel2)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-git-edited-widget
bindkey '^G' fzf-git-edited-widget

__fsel3() {
  local item
  git branch | $(__fzfcmd) +s +m -e --ansi --reverse | sed -e 's/^ *//' -e 's/^\* //' | while read item; do
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
# フロー制御を無効化して ^S を使えるようにする
stty -ixon


__fsel4() {
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
fzf-filename-first-widget() {
  LBUFFER="${LBUFFER}$(__fsel4)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf-filename-first-widget
bindkey '^T' fzf-filename-first-widget
bindkey '^W' fzf-filename-first-widget

globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}
zle -N globalias
bindkey " " globalias
