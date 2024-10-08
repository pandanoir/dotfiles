local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { desc = 'open lazy.nvim window' })

-- Any lua file in ~/.config/nvim/lua/plugins/*.lua will be automatically merged in the main plugin spec
require 'lazy'.setup('plugins', {
  change_detection = { notify = false },
  rocks = { enabled = false } -- TODO: deps関連を全部書き直す必要があるため、書き直しが終わったらtrueにする
})
