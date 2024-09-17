local keymap = vim.keymap.set

keymap('n', 'J', 'gJ')

keymap('n', '<CR>', ':<C-u>w<CR>')
keymap('n', '<leader><CR>', ':<C-u>noa w<CR>')

keymap('n', '<C-k><C-k>', ':set nohlsearch!<CR><Esc>')
keymap('n', '<leader>W', ':set wrap!<CR>', { desc = 'toggle wrap opt' })

-- qで終了、Qでマクロ
keymap('n', 'q', ':<C-u>q<CR>')
keymap('n', 'Q', 'q')

keymap('n', 'gy', '"+y')
keymap('n', '<leader>d', '"_d', { desc = 'delete without saving it in a register' })

-- クリップボードへコピー
keymap('n', '<leader>y', '"+y', { desc = 'copy to clipboard' })
keymap('v', '<leader>y', '"+y', { desc = 'copy to clipboard' })
keymap('n', '<leader>p', '"0p', { desc = 'paste from yank register' })

keymap('i', 'fd', '<Esc>', { remap = true, silent = true })

keymap('i', '<C-f>', '<Right>', { silent = true })
keymap('i', '<C-b>', '<Left>', { silent = true })

keymap('n', '<C-n>', ':bnext<CR>')
keymap('n', '<C-p>', ':bprev<CR>')

keymap('n', '<leader>c', ':<C-u>enew<CR>', { desc = 'open a new buffer' })
keymap('n', '<leader>q', ':<C-u>BufDel<CR>', { desc = 'quit' })
keymap('n', '<leader><Space>', '<C-v>')

-- 貼り付けたテキストの末尾へ自動的に移動する
keymap('v', 'y', 'y`]', { silent = true })
keymap('v', 'p', 'p`]', { silent = true })
keymap('n', 'p', 'p`]', { silent = true })

-- <, >で連続してインデントを操作
keymap('x', '<', '<gv')
keymap('x', '>', '>gv')

-- i<space>でWORD選択
keymap('o', 'i<space>', 'iW')
keymap('x', 'i<space>', 'iW')

-- Uでリドゥ
keymap('n', 'U', '<c-r>')

keymap('t', '<Esc>', [[<C-\><C-n>]])
keymap('t', 'fd', [[<C-\><C-n>]])


-- :s<Space> で:%s//|/g にする cf. https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
vim.cmd [[cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's']]

-- %% でアクティブなファイルが含まれているディレクトリを手早く展開
keymap('c', '%%', 'getcmdtype() == ":" ? expand("%:h")."/" : "%%"', { expr = true })
