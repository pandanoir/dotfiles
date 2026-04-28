local keymap = vim.keymap.set

keymap('n', 'J', 'gJ')

keymap('n', '<CR>', '<cmd>w<CR>')
keymap('n', '<leader><CR>', '<cmd>noa w<CR>')

keymap('n', '<leader><tab>h', function()
  vim.o.hlsearch = not vim.o.hlsearch
  vim.notify(('Search highlight %s'):format(vim.o.hlsearch and 'enabled' or 'disabled'))
end, { desc = 'toggle search highlight' })
keymap('n', '<leader><tab>w', function()
  vim.o.wrap = not vim.o.wrap
  vim.notify(('Line wrap %s'):format(vim.o.wrap and 'enabled' or 'disabled'))
end, { desc = 'toggle wrap opt' })

keymap('n', '<leader>e', vim.diagnostic.open_float, { silent = true, desc = 'show diagnostics in a floating window' })

-- qで終了、Qでマクロ
keymap('n', 'q', '<cmd>q<CR>')
keymap('n', 'Q', 'q')

keymap('n', '-', '"_')

-- クリップボードへコピー
keymap('n', '<leader>y', '"+y', { desc = 'copy to clipboard' })
keymap('v', '<leader>y', '"+y', { desc = 'copy to clipboard' })
keymap('n', '<leader>p', '"0p', { desc = 'paste from yank register' })

keymap('i', 'fd', '<Esc>', { remap = true, silent = true })

keymap('i', '<C-f>', '<Right>', { silent = true })
keymap('i', '<C-b>', '<Left>', { silent = true })

keymap('n', '<C-n>', '<cmd>bnext<CR>')
keymap('n', '<C-p>', '<cmd>bprev<CR>')

keymap('n', '<leader>c', '<cmd>enew<CR>', { desc = 'open a new buffer' })
keymap('n', '<leader>q', '<cmd>BufDel<CR>', { desc = 'quit' })
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

-- todoリストを簡単に入力する
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.cmd 'iabbrev <buffer> tl - [ ]'

    local function ToggleCheckbox()
      local line = vim.api.nvim_get_current_line()
      if string.match(line, '%-%s%[%s%]') then
        local result = string.gsub(line, '%-%s%[%s%]', '- [x]')
        vim.api.nvim_set_current_line(result)
      elseif string.match(line, '%-%s%[x%]') then
        local result = string.gsub(line, '%-%s%[x%]', '- [ ]')
        vim.api.nvim_set_current_line(result)
      end
    end

    keymap('n', '<leader>x', ToggleCheckbox, { buffer = true, silent = true })
    keymap('v', '<leader>x', ToggleCheckbox, { buffer = true, silent = true })
  end
})
