---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end

vim.scriptencoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-boms,utf-8,euc-jp,cp932' -- 読み込み時の文字コードの自動判別。左ほど優先される
vim.opt.fileformats = 'unix,dos,mac'                  -- 改行コードの自動判別。左ほど優先
vim.g.mapleader = ' '
vim.opt.cursorline = true
vim.opt.bg = 'dark'
vim.opt.signcolumn = 'yes:3'
vim.opt.mouse = ''
vim.opt.whichwrap = 'b,s,[,],,~'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.scrolloff = 10
-- Don't save options.
vim.opt.viewoptions:remove({ options = true })

vim.opt.backupskip = '/tmp/*,/private/tmp/*,/tmp/crontab.*'
vim.opt.writebackup = false

-- エラー時のビープ音をミュート
vim.opt.visualbell = true

require 'easy-setup-autocmd'.setup_autocmd {
  ['BufEnter,FileType'] = {
    pattern = '*',
    callback = function()
      -- 自動でコメントが入るのを防ぐ
      vim.opt_local.formatoptions:remove('ro')
    end
  },
  ['ColorScheme'] = {
    pattern = '*',
    callback = require 'improve-default-scheme'.improve
  }
}

vim.api.nvim_create_autocmd('FileType', {
  group = 'MyAutoCmd',
  pattern = 'markdown',
  callback = function()
    -- todoリストを簡単に入力する
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

-- " 対応するhtmlタグに % で移動できるようにする
vim.cmd [[packadd! matchit]]

require('disable-providers')
require('lazynvim')
require('keymappings')
require('userautoload.indent')
require('userautoload.filetype')
