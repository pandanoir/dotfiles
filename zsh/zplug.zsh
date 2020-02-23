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

zinit ice wait"1" lucid blockf atload"zpcompinit";          zinit light "mollifier/cd-bookmark"
zinit ice wait lucid atload"_zsh_autosuggest_start";        zinit light "zsh-users/zsh-autosuggestions"
zinit ice wait lucid blockf atpull"zinit creinstall -q .";  zinit light "zsh-users/zsh-completions"
zinit ice wait lucid;               zinit light "zsh-users/zsh-syntax-highlighting"
zinit ice wait"2" lucid;            zinit light "mollifier/zload"
zinit ice wait"2" lucid;            zinit light "momo-lab/zsh-replace-multiple-dots"
zinit ice wait lucid;               zinit light "changyuheng/fz"
zinit ice wait lucid pick"z.sh";    zinit light "rupa/z"
