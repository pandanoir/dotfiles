# zinit
# mkdir -p "$ZDOTDIR/.zinit/completions"

declare -A ZINIT
ZINIT[BIN_DIR]="$XDG_CACHE_HOME/zinit/bin"
ZINIT[HOME_DIR]="$XDG_CACHE_HOME/zinit"
ZINIT[PLUGINS_DIR]="$ZDOTDIR/.zinit/plugins"
ZINIT[COMPLETIONS_DIR]="$ZDOTDIR/.zinit/completions"

source "$XDG_CACHE_HOME/zinit/bin/zinit.zsh"
# source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# GitHub Actions 上では wait を削除して実行する
zinit_ice() {
  local args=()
  
  for arg in "$@"; do
    # GitHub Actions 上で実行している場合、wait コマンドを消す
    if [[ -n $GITHUB_ACTIONS && "$arg" == wait* ]]; then
      continue
    fi
    args+=("$arg")
  done
  
  zinit ice "${args[@]}"
}

zinit_ice wait"1" lucid blockf atload"zicompinit; zicdreplay";          zinit light "mollifier/cd-bookmark"
zinit_ice wait lucid atload"_zsh_autosuggest_start";        zinit light "zsh-users/zsh-autosuggestions"
zinit_ice wait lucid blockf atpull"zinit creinstall -q .";  zinit light "zsh-users/zsh-completions"
zinit_ice wait lucid;               zinit light "zsh-users/zsh-syntax-highlighting"
zinit_ice wait"2" lucid;            zinit light "mollifier/zload"
zinit_ice wait"2" lucid;            zinit light "momo-lab/zsh-replace-multiple-dots"
zinit_ice wait lucid;               zinit light "changyuheng/fz"
zinit_ice wait lucid pick"z.sh";    zinit light "rupa/z"
