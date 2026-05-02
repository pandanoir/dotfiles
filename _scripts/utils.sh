: "${XDG_CONFIG_HOME:="$HOME/.config"}"
: "${XDG_CACHE_HOME:="$HOME/.cache"}"
: "${XDG_DATA_HOME:="$HOME/.local/share"}"
: "${ZDOTDIR:="$XDG_CONFIG_HOME/zsh"}"

ARG1="$([ $# -eq 1 ] && echo "$1" || echo "")"
is_update_mode() { [ "$ARG1" = "update" ] || [ "$ARG1" = "-u" ]; }
file_exists() { [ -f $1 ]; }
dir_exists() { [ -d $1 ]; }
command_exists() { type "$1" >/dev/null 2>&1; }
info() { echo -e "\033[0;34m[INFO]\033[0;39m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0;39m $1"; }

