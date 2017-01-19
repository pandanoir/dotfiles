set laststatus=2
set statusline=%F " ファイル名表示
set statusline+=%m " 変更チェック表示
set statusline+=%r " 読み込み専用かどうか表示
set statusline+=%h " ヘルプページなら[HELP]と表示
set statusline+=%w " プレビューウインドウなら[Prevew]と表示
set statusline+=%= " これ以降は右寄せ表示
set statusline+=[ENC=%{&fileencoding}] " file encoding
set statusline+=[LOW=%l/%L] " 現在行数/全行数
