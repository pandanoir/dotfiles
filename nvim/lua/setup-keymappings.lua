vim.keymap.set('n', 'J', 'gJ')

vim.keymap.set('n', '<CR>', '<cmd>w<CR>')
vim.keymap.set('n', '<leader><CR>', '<cmd>noa w<CR>')

-- オプショントグル系
vim.keymap.set('n', '<leader><tab>h', function()
  vim.o.hlsearch = not vim.o.hlsearch
  vim.notify(('Search highlight %s'):format(vim.o.hlsearch and 'enabled' or 'disabled'))
end, { desc = 'toggle search highlight' })
vim.keymap.set('n', '<leader><tab>w', function()
  vim.o.wrap = not vim.o.wrap
  vim.notify(('Line wrap %s'):format(vim.o.wrap and 'enabled' or 'disabled'))
end, { desc = 'toggle wrap opt' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
  { silent = true, desc = 'show diagnostics in a floating window' })

-- qで終了、Qでマクロ
vim.keymap.set('n', 'q', '<cmd>q<CR>')
vim.keymap.set('n', 'Q', 'q')


-- ブラックホールレジスタ
vim.keymap.set('n', '-', '"_')

-- クリップボードへコピー
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'copy to clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'copy to clipboard' })
vim.keymap.set('n', '<leader>p', '"0p', { desc = 'paste from yank register' })

vim.keymap.set('i', 'fd', '<Esc>', { remap = true, silent = true })

vim.keymap.set('n', '<C-n>', '<cmd>bnext<CR>')
vim.keymap.set('n', '<C-p>', '<cmd>bprev<CR>')

vim.keymap.set('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'new buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>BufDel<CR>', { desc = 'delete buffer' })
vim.keymap.set('n', '<leader>q', '<cmd>BufDel<CR>', { desc = 'quit' })
vim.keymap.set({ 'n', 'v' }, '<leader><Space>', '<C-v>')

-- 貼り付けたテキストの末尾へ自動的に移動する
vim.keymap.set('v', 'y', 'y`]', { silent = true })
vim.keymap.set('v', 'p', 'p`]', { silent = true })
vim.keymap.set('n', 'p', 'p`]', { silent = true })

-- <, >で連続してインデントを操作
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- i<space>でWORD選択
vim.keymap.set('o', 'i<space>', 'iW')
vim.keymap.set('x', 'i<space>', 'iW')

-- Uでリドゥ
vim.keymap.set('n', 'U', '<c-r>')

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', 'fd', [[<C-\><C-n>]])


-- :s<Space> で:%s//|/g にする cf. https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
vim.cmd [[cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's']]

-- %% でアクティブなファイルが含まれているディレクトリを手早く展開
vim.keymap.set('c', '%%', 'getcmdtype() == ":" ? expand("%:h")."/" : "%%"', { expr = true })

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

    vim.keymap.set('n', '<leader>x', ToggleCheckbox, { buffer = true, silent = true })
    vim.keymap.set('v', '<leader>x', ToggleCheckbox, { buffer = true, silent = true })
  end
})
