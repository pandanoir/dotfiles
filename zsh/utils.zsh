has() {
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
add_to_path_if_not_exists() {
    local dir=$1
    if [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$PATH:$dir"
    fi
}
