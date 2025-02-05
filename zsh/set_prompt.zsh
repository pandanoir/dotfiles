git-prompt() {
  local branchname
  branchname=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -z $branchname ]; then
    return
  fi
  echo "%{${fg[magenta]}%}${branchname}%{${reset_color}%}"
}
prompt-set() {
  local user_host='%F{074}[%n@%m]'
  local last_status='%F{red}$([[ $? -ne 0 && $? -ne 130 ]] && echo "[%?]")' # 異常終了のとき(Ctrl-cを除く)にステータスを表示する
  PROMPT="$user_host$last_status%f# "
  RPROMPT='`git-prompt`%F{048}[%~]%f'
}
prompt-reset() {
  PROMPT="# "
  RPROMPT=''
}
prompt-set
setopt prompt_subst #表示毎にPROMPTで設定されている文字列を評価する
