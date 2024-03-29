local keymap = vim.keymap.set

keymap('n', '[space]', '<nop>')
keymap('n', '<Space>', '[space]', { remap = true })

keymap('n', 'J', 'gJ')

keymap('n', '<CR>', ':<C-u>w<CR>')

keymap('n', '<C-k><C-k>', ':set nohlsearch!<CR><Esc>')

-- qでウインドウを閉じて Qでマクロ
keymap('n', 'q', ':<C-u>q<CR>')
keymap('n', 'Q', 'q')

keymap('n', 'gy', '"+y')
keymap('n', '<leader>d', '"_d')

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'gj', 'j')
keymap('n', 'gk', 'k')

-- クリップボードへコピー
keymap('n', '<leader>y', '"+y')
keymap('v', '<leader>y', '"+y')
keymap('n', '<leader>p', '"0p')

keymap('i', 'fd', '<Esc>', { remap = true, silent = true })

keymap('i', '<C-f>', '<Right>', { silent = true })
keymap('i', '<C-b>', '<Left>', { silent = true })

keymap('n', '<C-n>', ':bnext<CR>')
keymap('n', '<C-p>', ':bprev<CR>')

keymap('', '<leader>c', ':<C-u>enew<CR>')
keymap('', '<leader>q', ':<C-u>bd<CR>')
keymap('', '<leader><Space>', '<C-v>')

keymap('', 'gv', '`[v`]') -- 貼り付けたテキストを素早く選択する

-- 貼り付けたテキストの末尾へ自動的に移動する
keymap('v', 'y', 'y`]', { silent = true })
keymap('v', 'p', 'p`]', { silent = true })
keymap('n', 'p', 'p`]', { silent = true })

-- :s<Space> で:%s//|/g にする cf. https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
vim.cmd [[cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's']]

-- %% でアクティブなファイルが含まれているディレクトリを手早く展開
keymap('c', '%%', 'getcmdtype() == ":" ? expand("%:h")."/" : "%%"', { expr = true })
