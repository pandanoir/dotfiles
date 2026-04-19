vim.pack.add({
  { src = 'https://github.com/folke/lazy.nvim.git', version = 'stable' },
}, { load = true })

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { desc = 'open lazy.nvim window' })

-- Any lua file in ~/.config/nvim/lua/plugins/*.lua will be automatically merged in the main plugin spec
require 'lazy'.setup {
  import = 'plugins',
  change_detection = { notify = false },
  -- rockspecを同梱しているプラグインがまだ少なく、hererocks等のセットアップ負荷に見合わないため無効化
  rocks = { enabled = false }
}
