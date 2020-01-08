expand-alias() {
    zle _expand_alias
    zle expand-word
}

zle -N expand-alias
bindkey '^O'    expand-alias

fancy-ctrl-z () {
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

_double_space_to_fzf() {
    if [[ "${LBUFFER}" =~ " $" ]]; then
        LBUFFER="${LBUFFER}$(__fsel)"
        local ret=$?
        zle redisplay
        return $ret
    else
        zle self-insert
    fi
}
zle -N _double_space_to_fzf
bindkey ' ' _double_space_to_fzf
bindkey '^ ' magic-space
