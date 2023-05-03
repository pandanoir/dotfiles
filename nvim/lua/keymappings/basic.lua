local keymap = vim.keymap.set

vim.g.mapleader = ','
keymap('n', 'J', 'gJ')

-- for masui special.
keymap('n', '<CR>', ':<C-u>w<CR>')

keymap('n', '<C-k><C-k>', ':set nohlsearch!<CR><Esc>')

-- qでウインドウを閉じて Qでマクロ
keymap('n', 'q', ':<C-u>q<CR>')
keymap('n', 'Q', 'q')
keymap('n', ';', ':')

keymap('v', ';', ':', { remap = true })

-- 削除時にヤンクしない
keymap('n', 'x', '"_x')
keymap('n', 'X', '"_X')
keymap('n', 'gy', '"+y')
-- vnoremap gy "+y
keymap('n', '<leader>d', '"_d')
-- vnoremap <leader>d "_d

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'gj', 'j')
keymap('n', 'gk', 'k')

-- クリップボードへコピー
keymap('n', '<leader>y', '"*y')
keymap('v', '<leader>y', '"*y')

keymap('i', 'fd', '<Esc>', { remap = true, silent = true })

keymap('i', '<C-f>', '<Right>', { silent = true })
keymap('i', '<C-b>', '<Left>', { silent = true })

keymap('c', '<C-b>', '<Left>')
keymap('c', '<C-f>', '<Right>')
keymap('c', '<C-n>', '<Down>')
keymap('c', '<C-p>', '<Up>')
keymap('c', '<C-a>', '<Home>')
keymap('c', '<C-e>', '<End>')
keymap('c', '<C-d>', '<Del>')

keymap('n', '<C-n>', ':bnext<CR>')
keymap('n', '<C-p>', ':bprev<CR>')

-- ,のデフォルトの機能は、\で使えるように退避
keymap('', [[\]], ',')

keymap('n', '[space]', '<nop>')
keymap('n', '<Space>', '[space]', { remap = true })
keymap('', '[space]c', ':<C-u>enew<CR>')

keymap('', '[space]d', ':<C-u>bd<CR>')
