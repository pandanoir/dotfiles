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

