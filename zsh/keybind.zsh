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

__fsel() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    eval "${FZF_CTRL_T_COMMAND}" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m | while read item; do
        echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
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
