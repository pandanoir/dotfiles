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

__fsel2() {
    local item

    git status --porcelain --untracked-files |
    fzf +s +m -e --multi --ansi --reverse --height 40% --preview='git diff --color $('"echo {} | awk '{print substr(\$0,4)}') | tail -n +5" |
    awk '{print substr($0,4)}' |
    while read item; do
        echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
fzf-git-edited-widget() {
    LBUFFER="${LBUFFER}$(__fsel2)"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle -N fzf-git-edited-widget
bindkey '^X^W' fzf-git-edited-widget
