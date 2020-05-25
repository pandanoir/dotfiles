has() {
    type "$1" > /dev/null 2>&1
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

