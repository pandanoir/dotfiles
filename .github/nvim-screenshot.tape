Set Shell "bash"
Set FontFamily "Hack Nerd Font Mono"
Set FontSize 42
Set Width 2400
Set Height 1600
Set Theme "Molokai"
Env TERM "xterm-256color"
Env COLORTERM "truecolor"

Type "nvim"
Enter
Sleep 3s
Screenshot _assets/nvim-startup.png

Type ":e nvim/init.lua"
Enter
Sleep 2s
Screenshot _assets/nvim-screenshot.png
Type ":qa!"
Enter
