function fvim
    set -l files (fzf-tmux)
    [ -n "$files" ]; and vim $files
end

