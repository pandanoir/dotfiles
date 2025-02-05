# emacsのtrampがタイムアウトするのに対応
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

bindkey -e # キーバインディングをEmacsモードに設定する

autoload -U colors
colors # 色に関連する変数(fg、bg、fx など)を設定して色付きのプロンプトやスクリプトを使えるようにする

setopt no_beep  # ビープ音を消す
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt auto_cd # cdでディレクトリ移動時にlsを実行する

# コマンド履歴関連
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
SAVEHIST=100
HISTFILE=$HOME/.zsh_history

# プロンプト
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
