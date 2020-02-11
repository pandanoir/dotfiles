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

bindkey '^W' fzf-file-widget
