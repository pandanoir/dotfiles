command_exists() {
  type "$1" >/dev/null 2>&1
}
dir_exists() {
  [ -d "$1" ]
}
file_exists() {
  [ -f $1 ]
}
is_empty_string() {
  [ -z "$1" ]
}
is_mac() {
  [ "$(uname)" = 'Darwin' ]
}
is_claude() {
  [[ -n "$CLAUDECODE" ]]
}
add_to_path_if_not_exists() {
  local dir=$1
  if [[ ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
  fi
}
source_if_exists() {
  file_exists "$1" && source "$1"
}
debug() {
  if is_claude; then
    return
  fi
  local YELLOW="\033[1;33m"
  local RESET="\033[0m"

  echo -e "${YELLOW}[DEBUG]${RESET} $1"
}
notify() {
  if is_claude; then
    return
  fi
  blue="\033[34m"
  reset="\033[0m"
  echo -ne "\033[1K\r${blue}[INFO]${reset} $1"
}
source_notify() {
  notify "loading $1..."
  source "$1"
}
source_notify_if_exists() {
  notify "loading $1..."
  source_if_exists "$1"
}
