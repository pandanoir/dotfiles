local keymap = vim.keymap.set

keymap('n', '[space]', '<nop>')
keymap('n', '<Space>', '[space]', { remap = true })

keymap('n', 'J', 'gJ')

-- for masui special.
keymap('n', '<CR>', ':<C-u>w<CR>')

keymap('n', '<C-k><C-k>', ':set nohlsearch!<CR><Esc>')

-- qでウインドウを閉じて Qでマクロ
keymap('n', 'q', ':<C-u>q<CR>')
keymap('n', 'Q', 'q')

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
